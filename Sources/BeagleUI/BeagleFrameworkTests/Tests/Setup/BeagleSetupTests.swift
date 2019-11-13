//
//  BeagleSetupTests.swift
//  BeagleFrameworkTests
//
//  Created by Eduardo Sanches Bocato on 15/10/19.
//  Copyright © 2019 Daniel Tes. All rights reserved.
//

import XCTest
@testable import BeagleUI
import Networking

final class BeagleSetupTests: XCTestCase {
    
    func test_start_shouldStartTheEnvironment() {
        // Given
        let environmentSpy = BeagleEnvironmentSpy.self
        Beagle.didCallStart = false
        Beagle.environment = environmentSpy
        
        // When
        Beagle.start()
        
        // Then
        XCTAssertTrue(environmentSpy.initializeCalled)
    }
    
    func test_start_shouldThrowFatalErrorIfCalledTwice() {
        // Given
        let environmentSpy = BeagleEnvironmentSpy.self
        Beagle.didCallStart = false
        Beagle.environment = environmentSpy
        Beagle.start()
        
        // When / Then
        expectFatalError(expectedMessage: "Beagle.start should be called only one time!") {
            Beagle.start()
        }
    }
    
    func test_start_shouldStartTheEnviromentWithRightBundle() {
        // Given
        let environmentSpy = BeagleEnvironmentSpy.self
        Beagle.didCallStart = false
        Beagle.environment = environmentSpy
        let bundle = Bundle()
        
        // When
        Beagle.start(appName: "appName", appBundle: bundle)
        
        // Then
        XCTAssertNotNil(environmentSpy.bundlePassed, "Expected a bundle to be passed.")
        XCTAssertEqual(bundle, environmentSpy.bundlePassed)
    }
    
    func test_registerCustomWidgets_shouldCallRegisterWidgetsOnEnvironment_passingOnlyOneWidget() {
        // Given
        let environmentSpy = BeagleEnvironmentSpy.self
        Beagle.didCallStart = false
        Beagle.environment = environmentSpy
        Beagle.start()
        let customWidgetToRegister = WidgetRegisterItem(
            entity: .init(
                typeName: "WidgetDummy",
                type: WidgetDummyEntity.self
            ),
            view: .init(
                widgetType: WidgetDummy.self,
                viewRenderer: WidgetViewRendererDummy.self
            )
        )
        
        // When
        Beagle.registerCustomWidget(customWidgetToRegister)
        
        // Then
        guard let sharedInstance = environmentSpy._shared else {
            XCTFail("Could not find sharedInstance.")
            return
        }
        
        XCTAssertTrue(sharedInstance.registerCustomWidgetsCalled, "`registerCustomWidgets` should have been called on the invironment.")
        XCTAssertNotNil(sharedInstance.itemPassed, "An item should have been passed.")
    }
    
    func test_start_shouldStartTheEnviromentWithAppThemeConfigured() {
        // Given
        let environmentSpy = BeagleEnvironmentSpy.self
        Beagle.didCallStart = false
        Beagle.environment = environmentSpy
        let theme = AppThemeDummy()
        
        // When
        Beagle.start(applicationTheme: theme)
        
        // Then
        XCTAssertTrue(environmentSpy.initializeCalled)
        XCTAssertNotNil(environmentSpy.applicationThemePassed)
        XCTAssertTrue(theme === environmentSpy.applicationThemePassed as? AppThemeDummy)
    }
    
    func test_configureTheme_shouldCallConfigureTheme_passingTheme() {
        // Given
        let environmentSpy = BeagleEnvironmentSpy.self
        Beagle.didCallStart = false
        Beagle.environment = environmentSpy
        let theme = AppThemeDummy()
        
        // When
        Beagle.start()
        Beagle.configureTheme(theme)
        
        // Then
        guard let sharedInstance = environmentSpy._shared else {
            XCTFail("Could not find sharedInstance.")
            return
        }
        XCTAssertTrue(sharedInstance.configureThemeCalled)
        XCTAssertNotNil(sharedInstance.themePassed)
        XCTAssertTrue(theme === sharedInstance.themePassed as? AppThemeDummy)
    }
}

// MARK: - Testing Helpers

final class BeagleEnvironmentSpy: BeagleEnvironmentProtocol {
    private(set) var appBundleCalled = false
    var appBundle: Bundle {
        appBundleCalled = true
        return Bundle()
    }
    
    private(set) var decoderCalled = false
    var decoder: WidgetDecoding {
        decoderCalled = true
        return WidgetDecodingDummy()
    }
    
    private(set) var networkingDispatcherCalled = false
    var networkingDispatcher: URLRequestDispatching {
        networkingDispatcherCalled = true
        return URLRequestDispatchingDummy()
    }
    
    var customWidgetsProvider: CustomWidgetsRendererProviderDequeuing { CustomWidgetsRendererProviderDequeuingDummy() }
    
    private(set) var applicationThemeCalled = false
    var applicationTheme: Theme {
        applicationThemeCalled = true
        return AppThemeDummy()
    }
    
    private(set) static var _shared: BeagleEnvironmentSpy?
    static var shared: BeagleEnvironmentProtocol {
        return _shared!
    }
    
    init() {}
    
    static private(set) var initializeCalled = false
    static private(set) var bundlePassed: Bundle?
    static private(set) var applicationThemePassed: Theme?
    static func initialize(appName: String,
                           decoder: WidgetDecoding,
                           networkingDispatcher: URLRequestDispatching,
                           customWidgetsRendererProviderRegister: CustomWidgetsRendererProviderDequeuing & CustomWidgetsRendererProviderRegistering,
                           appBundle: Bundle,
                           applicationTheme: Theme
    ) {
        _shared = BeagleEnvironmentSpy()
        initializeCalled = true
        bundlePassed = appBundle
        applicationThemePassed = applicationTheme
    }
    
    static func initialize(appName: String, networkingDispatcher: URLRequestDispatching?, appBundle: Bundle?, applicationTheme: Theme?) {
        initialize(
            appName: appName,
            decoder: WidgetDecodingDummy(),
            networkingDispatcher: networkingDispatcher ?? URLRequestDispatchingDummy(),
            customWidgetsRendererProviderRegister: CustomWidgetsRendererProviderDummy(),
            appBundle: appBundle ?? Bundle.main,
            applicationTheme: applicationTheme ?? AppThemeDummy()
        )
    }
    
    private(set) var registerCustomWidgetsCalled = false
    private(set) var itemPassed: Any?
    func registerCustomWidget<E, W>(_ item: WidgetRegisterItem<E, W>) where E : WidgetConvertible, E : WidgetEntity, W : Widget {
        registerCustomWidgetsCalled = true
        itemPassed = item
    }
    
    private(set) var configureThemeCalled = false
    private(set) var themePassed: Theme?
    func configureTheme(_ theme: Theme) {
        configureThemeCalled = true
        themePassed = theme
    }
}

final class WidgetDecodingDummy: WidgetDecoding {
    func register<T>(_ type: T.Type, for typeName: String) where T : WidgetEntity {}
    func decode(from data: Data) throws -> WidgetEntity? { return nil }
    func decodeToWidget<T>(ofType type: T.Type, from data: Data) throws -> T where T : Widget { return WidgetDummy() as! T }
    func decode<T>(from data: Data, transformer: (Widget) throws -> T?) throws -> T? { return nil }
}

final class CustomWidgetsRendererProviderDequeuingDummy: CustomWidgetsRendererProviderDequeuing {
    func dequeueRenderer(for widget: Widget) throws -> WidgetViewRendererProtocol {
        return try WidgetViewRendererDummy(widget)
    }
}

final class WidgetViewRendererDummy: WidgetViewRenderer<WidgetDummy> {
    override func buildView(context: BeagleContext) -> UIView { return UIView() }
}

final class CustomWidgetsRendererProviderDummy: CustomWidgetsRendererProviderDequeuing, CustomWidgetsRendererProviderRegistering {
    func registerRenderer<W>(_ rendererType: WidgetViewRenderer<W>.Type, for widgetType: W.Type) where W : Widget {}
    func dequeueRenderer(for widget: Widget) throws -> WidgetViewRendererProtocol {
        return try WidgetViewRendererDummy(widget)
    }
}

struct WidgetDummyEntity: WidgetConvertibleEntity {
    func mapToWidget() throws -> Widget {
        return WidgetDummy()
    }
}

class URLRequestDispatchingDummy: URLRequestDispatching {
    func execute(on queue: DispatchQueue, request: URLRequestProtocol, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLRequestToken? {
        return nil
    }
}

final class AppThemeDummy: Theme {
    func applyStyle<T>(for view: T, withId id: String) where T : UIView {
        
    }
}
