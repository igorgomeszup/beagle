//
//  NavigatorWidgetViewRenderer.swift
//  BeagleUI
//
//  Created by Lucas Araújo on 05/11/19.
//  Copyright © 2019 Zup IT. All rights reserved.
//

import UIKit

final class NavigatorWidgetViewRenderer: WidgetViewRenderer<Navigator> {
    
    private var context: BeagleContext?
    
    // MARK: - Public Functions
    
    override func buildView(context: BeagleContext) -> UIView {
        let child = widget.child
        let childRenderer = rendererProvider.buildRenderer(for: child)
        let childView = childRenderer.buildView(context: context)
        context.register(action: widget.action, inView: childView)
        return childView
    }
    
}
