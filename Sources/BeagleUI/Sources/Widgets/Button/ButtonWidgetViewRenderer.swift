//
//  Copyright © 2019 Zup IT. All rights reserved.
//

import UIKit

final class ButtonWidgetViewRenderer: ViewRendering<Button> {
    
    // MARK: - Public Functions
    
    override func buildView(context: BeagleContext) -> UIView {
        
        let button = UIButton(type: .system)
        button.setTitle(widget.text, for: .normal)
        
        if let style = widget.style {
            dependencies.theme.applyStyle(for: button, withId: style)
        }
        
        return button
    }
    
}
