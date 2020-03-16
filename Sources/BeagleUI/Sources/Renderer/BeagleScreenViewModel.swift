//
//  Copyright © 26/12/19 Zup IT. All rights reserved.
//

import UIKit

public protocol RemoteScreenAdditionalData {
    typealias Http = HttpAdditionalData

}

public class BeagleScreenViewModel {

    // MARK: ScreenType

    var screenType: ScreenType
    
    public enum ScreenType {
        case remote(Remote)
        case declarative(Screen)
        case declarativeText(String)

        public struct Remote {
            let url: String
            let fallback: Screen?
            let additionalData: RemoteScreenAdditionalData?

            public init(
                url: String,
                fallback: Screen? = nil,
                additionalData: RemoteScreenAdditionalData? = nil
            ) {
                self.url = url
                self.fallback = fallback
                self.additionalData = additionalData
            }
        }
    }

    // MARK: State

    private(set) var state: State {
        didSet { didChangeState() }
    }
    
    private(set) var screen: Screen?

    public enum State {
        case loading
        case success
        case failure(Request.Error)
        case rendered
    }

    // MARK: Dependencies

    var dependencies: Dependencies

    public typealias Dependencies =
        DependencyActionExecutor
        & DependencyNetwork
        & RenderableDependencies
        & DependencyComponentDecoding

    // MARK: Delegate and Observer

    public weak var delegate: BeagleScreenDelegate?

    public weak var stateObserver: BeagleScreenStateObserver? {
        didSet { stateObserver?.didChangeState(state) }
    }

    // MARK: Init

    public init(
        screenType: ScreenType,
        dependencies: Dependencies = Beagle.dependencies,
        delegate: BeagleScreenDelegate? = nil
    ) {
        self.screenType = screenType
        self.dependencies = dependencies
        self.delegate = delegate

        switch screenType {
        case .declarative(let screen):
            self.screen = screen
            state = .success
        case .declarativeText(let text):
            state = .loading
            self.tryToLoadScreenFromText(text)
        case .remote(let remote):
            state = .loading
            loadRemoteScreen(remote)
        }
    }

    public func reloadScreen(with screenType: ScreenType) {
        state = .loading
        self.screenType = screenType
        switch screenType {
        case .declarative(let screen):
            self.screen = screen
            state = .success
        case .declarativeText(let text):
            state = .loading
            self.tryToLoadScreenFromText(text)
        case .remote(let remote):
            state = .loading
            loadRemoteScreen(remote)
        }
    }

    // MARK: Core

    func tryToLoadScreenFromText(_ text: String) {
        guard let loadedScreen = loadScreenFromText(text) else {
            state = .failure(Request.Error.loadFromTextError)
            return
        }
        screen = loadedScreen
        state = .success
    }

    func loadScreenFromText(_ text: String) -> Screen? {

        guard let data = text.data(using: .utf8) else { return nil }
        let component = try? self.dependencies.decoder.decodeComponent(from: data)

        guard let screen = component as? ScreenComponent else {
            return nil
        }

        return Screen(child: screen)
    }

    func loadRemoteScreen(_ remote: ScreenType.Remote) {
        if let cached = dependencies.cacheManager.dequeueComponent(path: remote.url) {
            handleSuccess(cached)
            return
        }
        
        state = .loading

        dependencies.network.fetchComponent(
            url: remote.url,
            additionalData: remote.additionalData
        ) {
            [weak self] result in guard let self = self else { return }
            
            switch result {
            case .success(let component):
                self.handleSuccess(component)
            case .failure(let error):
                self.handleFailure(error)
            }
        }
    }
    
    func didRenderComponent() {
        state = .rendered
    }

    func handleError(_ error: Request.Error) {
        delegate?.beagleScreen(viewModel: self, didFailToLoadWithError: error)
    }
    
    // MARK: - Private
    
    private func handleSuccess(_ component: ServerDrivenComponent) {
        screen = component.toScreen()
        state = .success
    }
    
    private func handleFailure(_ error: Request.Error) {
        if case let .remote(remote) = self.screenType, let screen = remote.fallback {
            self.screen = screen
        }
        self.state = .failure(error)
    }

    private func didChangeState() {
        stateObserver?.didChangeState(state)

        guard case .failure(let error) = state else { return }

        handleError(error)
    }
}

// MARK: - Delegate and Observer

public protocol BeagleScreenDelegate: AnyObject {
    typealias ViewModel = BeagleScreenViewModel

    func beagleScreen(
        viewModel: ViewModel,
        didFailToLoadWithError error: Request.Error
    )
}

public protocol BeagleScreenStateObserver: AnyObject {
    typealias ViewModel = BeagleScreenViewModel

    func didChangeState(_ state: ViewModel.State)
}
