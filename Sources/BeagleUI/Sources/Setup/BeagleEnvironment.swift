//
//  BeagleEnvironment.swift
//  BeagleUI
//
//  Created by Eduardo Sanches Bocato on 14/10/19.
//  Copyright © 2019 Daniel Tes. All rights reserved.
//

import Foundation
import Networking

protocol BeagleEnvironmentProtocol {
    
    // MARK: - Properties
    var decoder: WidgetDecoding { get }
    var networkingDispatcher: URLRequestDispatching { get }
    var customWidgetsProvider: CustomWidgetsRendererProviderDequeuing { get }
    var appBundle: Bundle { get }
    var applicationTheme: Theme { get }
    var validatorHandler: ValidatorHandler? { get }
    var deepLinkHandler: BeagleDeepLinkScreenManaging? { get }
    var customActionHandler: CustomActionHandler? { get }
    
    // MARK: - Singleton
    static var shared: BeagleEnvironmentProtocol { get }
    
    // MARK: - Initialization
    static func initialize(
        appName: String,
        decoder: WidgetDecoding,
        networkingDispatcher: URLRequestDispatching,
        customWidgetsRendererProviderRegister: CustomWidgetsRendererProviderRegistering & CustomWidgetsRendererProviderDequeuing,
        appBundle: Bundle,
        deepLinkHandler: BeagleDeepLinkScreenManaging?,
        applicationTheme: Theme,
        validatorHandler: ValidatorHandler?,
        customActionHandler: CustomActionHandler?
    )
    static func initialize(appName: String, networkingDispatcher: URLRequestDispatching?, appBundle: Bundle?, deepLinkHandler: BeagleDeepLinkScreenManaging?, applicationTheme: Theme?, validatorHandler: ValidatorHandler?, customActionHandler: CustomActionHandler?)
    // MARK: - Public Functions
    func registerCustomWidget<E: WidgetConvertibleEntity, W: Widget>(_ item: WidgetRegisterItem<E, W>)
    func configureTheme(_ theme: Theme)
    
    func configureValidatorHandler(_ validatorHandler: ValidatorHandler?)
    
    func configureCustomActionHandler(_ customActionHandler: CustomActionHandler?)
}

final class BeagleEnvironment: BeagleEnvironmentProtocol {
    
    // MARK: - Dependencies
    
    private let _decoder: WidgetDecoding
    private let _networkingDispatcher: URLRequestDispatching
    private let customWidgetsRendererProviderRegister: CustomWidgetsRendererProviderRegistering & CustomWidgetsRendererProviderDequeuing
    private let _appBundle: Bundle
    private let _deepLinkHandler: BeagleDeepLinkScreenManaging?
    private var _applicationTheme: Theme
    private var _validatorHandler: ValidatorHandler?
    private var _customActionHandler: CustomActionHandler?
    
    // MARK: - Public Properties
    
    var decoder: WidgetDecoding { _decoder }
    var networkingDispatcher: URLRequestDispatching { _networkingDispatcher }
    var customWidgetsProvider: CustomWidgetsRendererProviderDequeuing { customWidgetsRendererProviderRegister }
    var appBundle: Bundle { _appBundle }
    var deepLinkHandler: BeagleDeepLinkScreenManaging? { _deepLinkHandler }
    var applicationTheme: Theme { _applicationTheme }
    var validatorHandler: ValidatorHandler? { _validatorHandler }
    var customActionHandler: CustomActionHandler? { _customActionHandler }
    
    // MARK: - Singleton
    
    private static var _shared: BeagleEnvironment?
    static var shared: BeagleEnvironmentProtocol {
        guard let shared = BeagleEnvironment._shared else {
            fatalError("BeagleEnvironment was not initialized, check that!")
        }
        return shared
    }
    
    // MARK: - Initialization
    
    private init(
        decoder: WidgetDecoding,
        networkingDispatcher: URLRequestDispatching,
        customWidgetsRendererProviderRegister: CustomWidgetsRendererProviderRegistering & CustomWidgetsRendererProviderDequeuing,
        appBundle: Bundle,
        deepLinkHandler: BeagleDeepLinkScreenManaging?,
        applicationTheme: Theme,
        validatorHandler: ValidatorHandler?,
        customActionHandler: CustomActionHandler?
    ) {
        self._decoder = decoder
        self._networkingDispatcher = networkingDispatcher
        self.customWidgetsRendererProviderRegister = customWidgetsRendererProviderRegister
        self._appBundle = appBundle
        self._deepLinkHandler = deepLinkHandler
        self._applicationTheme = applicationTheme
        self._validatorHandler = validatorHandler
        self._customActionHandler = customActionHandler
    }
    
    // MARK: - Public Functions
    
    static func initialize(
        appName: String,
        decoder: WidgetDecoding,
        networkingDispatcher: URLRequestDispatching,
        customWidgetsRendererProviderRegister: CustomWidgetsRendererProviderRegistering & CustomWidgetsRendererProviderDequeuing = CustomWidgetsRendererProviderRegister(),
        appBundle: Bundle,
        deepLinkHandler: BeagleDeepLinkScreenManaging?,
        applicationTheme: Theme,
        validatorHandler: ValidatorHandler?,
        customActionHandler: CustomActionHandler?
    ) {
        let decoderInstance = decoder
        _shared = BeagleEnvironment(
            decoder: decoderInstance,
            networkingDispatcher: networkingDispatcher,
            customWidgetsRendererProviderRegister: customWidgetsRendererProviderRegister,
            appBundle: appBundle,
            deepLinkHandler: deepLinkHandler,
            applicationTheme: applicationTheme,
            validatorHandler: validatorHandler,
            customActionHandler: customActionHandler
        )
    }
    
    static func initialize(appName: String, networkingDispatcher: URLRequestDispatching? = nil, appBundle: Bundle? = nil, deepLinkHandler: BeagleDeepLinkScreenManaging? = nil, applicationTheme: Theme? = nil, validatorHandler: ValidatorHandler? = nil, customActionHandler: CustomActionHandler? = nil) {
        let decoder = WidgetDecoder(namespace: appName)
        let dispatcher = networkingDispatcher ?? URLSessionDispatcher()
        initialize(appName: appName, decoder: decoder, networkingDispatcher: dispatcher, appBundle: appBundle ?? Bundle.main, deepLinkHandler: deepLinkHandler, applicationTheme: applicationTheme ?? AppTheme(styles: [:]), validatorHandler: validatorHandler, customActionHandler: customActionHandler)
    }
    
    func registerCustomWidget<E: WidgetConvertibleEntity, W: Widget>(_ item: WidgetRegisterItem<E, W>) {
        decoder.register(item.entity.type, for: item.entity.typeName)
        customWidgetsRendererProviderRegister.registerRenderer(item.view.viewRenderer, for: item.view.widgetType)
    }
    
    func configureTheme(_ theme: Theme) {
        _applicationTheme = theme
    }
    
    func configureValidatorHandler(_ validatorHandler: ValidatorHandler?) {
        _validatorHandler = validatorHandler
    }
    
    func configureCustomActionHandler(_ customActionHandler: CustomActionHandler?) {
        _customActionHandler = customActionHandler
    }
}
