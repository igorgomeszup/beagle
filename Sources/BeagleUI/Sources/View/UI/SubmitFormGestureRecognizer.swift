//
//  SubmitFormGestureRecognizer.swift
//  BeagleUI
//
//  Created by Lucas Araújo on 22/11/19.
//  Copyright © 2019 Zup IT. All rights reserved.
//

import UIKit

final class SubmitFormGestureRecognizer: UITapGestureRecognizer {
    
    let form: Form
    weak var formView: UIView?
    let validator: ValidatorHandler?
    
    init(form: Form, formView: UIView, validator: ValidatorHandler?, target: Any? = nil, action: Selector? = nil) {
        self.form = form
        self.formView = formView
        self.validator = validator
        super.init(target: target, action: action)
    }
    
    func formInputViews() -> [UIView] {
        var inputViews = [UIView]()
        var pendingViews = [UIView]()
        if let formView = formView {
            pendingViews.append(formView)
        }
        while let view = pendingViews.popLast() {
            if view.beagleFormElement is FormInput {
                inputViews.append(view)
            } else {
                pendingViews.append(contentsOf: view.subviews)
            }
        }
        return inputViews
    }
    
}
