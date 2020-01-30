//
//  Copyright © 2019 Zup IT. All rights reserved.
//

import XCTest
@testable import BeagleUI
import SnapshotTesting

final class BeagleSetupTests: XCTestCase {

    func testDefaultDependencies() {
        let dependencies = BeagleDependencies(appName: "TEST")
        assertSnapshot(matching: dependencies, as: .dump)
    }

    func testChangedDependencies() {
        let dep = BeagleDependencies(appName: "TEST")
        dep.appBundle = Bundle.main
        dep.deepLinkHandler = DeepLinkHandlerDummy()
        dep.theme = AppThemeDummy()
        dep.validatorProvider = ValidatorProviding()
        dep.customActionHandler = CustomActionHandlerDummy()
        if let url = URL(string: "www.test.com") {
            dep.baseURL = url
        }
        dep.networkDispatcher = URLRequestDispatchingDummy()
        dep.flex = FlexViewConfiguratorDummy()
        dep.decoder = WidgetDecodingDummy()

        assertSnapshot(matching: dep, as: .dump)
    }

    func test_ifChangingDependency_othersShouldUseNewInstance() {
        let dependencies = BeagleDependencies(appName: "TEST")

        let actionSpy = CustomActionHandlerSpy()
        dependencies.customActionHandler = actionSpy

        let dummyAction = CustomAction(name: "", data: [:])

        dependencies.actionExecutor.doAction(
            dummyAction,
            sender: self,
            context: BeagleContextDummy()
        )

        XCTAssert(actionSpy.actionsHandledCount == 1)
    }
}

// MARK: - Testing Helpers

final class DeepLinkHandlerDummy: BeagleDeepLinkScreenManaging {
    func getNaviteScreen(with path: String, data: [String: String]?) throws -> UIViewController {
        return UIViewController()
    }
}

final class WidgetDecodingDummy: WidgetDecoding {
    func register<T>(_ type: T.Type, for typeName: String) where T: WidgetEntity {}
    func decodableType(forType type: String) -> Decodable.Type? { return nil }
    func decodeWidget(from data: Data) throws -> Widget { return WidgetDummy() }
    func decodeAction(from data: Data) throws -> Action { return ActionDummy() }
}

struct WidgetDummy: Widget {
    func toView(context: BeagleContext, dependencies: Renderable.Dependencies) -> UIView {
        return DummyView()
    }
}

final class DummyView: UIView {}

struct ActionDummy: Action {}

class BeagleContextDummy: BeagleContext {
    var screenController: UIViewController = UIViewController()
    
    func register(action: Action, inView view: UIView) {}
    func register(form: Form, formView: UIView, submitView: UIView, validator: ValidatorProvider?) {}
    func lazyLoad(url: String, initialState: UIView) {}
    func doAction(_ action: Action, sender: Any) {}
}

struct RendererDependenciesContainer: Renderable.Dependencies {
    var flex: FlexViewConfiguratorProtocol
    var theme: Theme
    var validatorProvider: ValidatorProvider?
    var appBundle: Bundle

    init(
        flex: FlexViewConfiguratorProtocol = FlexViewConfiguratorDummy(),
        theme: Theme = AppThemeDummy(),
        validatorProvider: ValidatorProvider? = ValidatorProviding(),
        appBundle: Bundle = Bundle(for: ImageTests.self)
    ) {
        self.flex = flex
        self.theme = theme
        self.validatorProvider = validatorProvider
        self.appBundle = appBundle
    }
}

struct WidgetDummyEntity: WidgetConvertibleEntity {
    func mapToWidget() throws -> Widget {
        return WidgetDummy()
    }
}

class URLRequestDispatchingDummy: NetworkDispatcher {
    func execute(on queue: DispatchQueue, request: URLRequestProtocol, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLRequestToken? {
        return nil
    }
}

final class AppThemeDummy: Theme {
    func applyStyle<T>(for view: T, withId id: String) where T: UIView {

    }
}
