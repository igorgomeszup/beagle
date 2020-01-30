//
//  Copyright © 2019 Zup IT. All rights reserved.
//

import UIKit

public struct ScrollView: Widget, HasAppearance {
    
    // MARK: - Public Properties
    
    public let children: [Widget]
    public let appearance: Appearance?
    
    // MARK: - Initialization

    public init(
        children: [Widget],
        appearance: Appearance? = nil
    ) {
        self.children = children
        self.appearance = appearance
    }
    
}

extension ScrollView: Renderable {
    public func toView(context: BeagleContext, dependencies: Renderable.Dependencies) -> UIView {
        let scrollView = BeagleContainerScrollView()
        let contentView = UIView()
        
        children.forEach {
            let childView = $0.toView(context: context, dependencies: dependencies)
            contentView.addSubview(childView)
            dependencies.flex.enableYoga(true, for: childView)
        }
        scrollView.addSubview(contentView)
        scrollView.applyAppearance(appearance)
        
        let flexContent = Flex(grow: 0, shrink: 0)
        dependencies.flex.setupFlex(flexContent, for: contentView)
        
        return scrollView
    }
}

final class BeagleContainerScrollView: UIScrollView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if let contentView = subviews.first {
            contentSize = contentView.frame.size
        }
    }
}
