//
//  Button.swift
//  BeagleUI
//
//  Created by Daniel Tes on 12/09/19.
//  Copyright © 2019 Daniel Tes. All rights reserved.
//

public struct Button: NativeWidget {
    
    // MARK: - Public Properties
    
    public let text: String
    public let style: String?
    
    public init(
        text: String,
        style: String? = nil
    ) {
        self.text = text
        self.style = style
    }
}
