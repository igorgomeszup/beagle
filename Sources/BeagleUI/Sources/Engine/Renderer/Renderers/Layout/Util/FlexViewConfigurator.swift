//
//  FlexViewConfigurator.swift
//  BeagleUI
//
//  Created by Eduardo Sanches Bocato on 09/10/19.
//  Copyright © 2019 Daniel Tes. All rights reserved.
//

import Foundation
import YogaKit

public protocol FlexViewConfiguratorProtocol {
    func setupFlex(_ flex: Flex, for view: UIView)
    func applyYogaLayout(to view: UIView, preservingOrigin: Bool)
    func enableYoga(_ enable: Bool, for view: UIView)
}

final class FlexViewConfigurator: FlexViewConfiguratorProtocol {
    
    // MARK: - Dependencies
    
    private let yogaTranslator: YogaTranslator
    
    // MARK: - Initialization
    
    init(yogaTranslator: YogaTranslator = YogaTranslating()) {
        self.yogaTranslator = yogaTranslator
    }
    
    // MARK: - Public Methods
    
    func setupFlex(_ flex: Flex, for view: UIView) {
        enableYoga(true, for: view)
        applyYogaProperties(from: flex, to: view.yoga)
        applyAtributes(from: flex, to: view.yoga)
    }
    
    func applyYogaLayout(to view: UIView, preservingOrigin: Bool) {
        enableYoga(true, for: view)
        view.yoga.applyLayout(preservingOrigin: preservingOrigin)
    }
    
    func enableYoga(_ enable: Bool, for view: UIView) {
        view.yoga.isEnabled = enable
    }
    
    // MARK: - Private Methods
    
    private func applyYogaProperties(from flex: Flex, to layout: YGLayout) {
        
        if let flexDirection = flex.flexDirection {
            layout.flexDirection = yogaTranslator.translate(flexDirection)
        }
        
        if let direction = flex.direction {
           layout.direction = yogaTranslator.translate(direction)
        }
        
        if let flexWrap = flex.flexWrap {
            layout.flexWrap = yogaTranslator.translate(flexWrap)
        }
        
        if let justifyContent = flex.justifyContent {
            layout.justifyContent = yogaTranslator.translate(justifyContent)
        }
        
        if let alignItems = flex.alignItems {
            layout.alignItems = yogaTranslator.translate(alignItems)
        }
        
        if let alignSelf = flex.alignSelf {
            layout.alignSelf = yogaTranslator.translate(alignSelf)
        }
        
        if let alignContent = flex.alignContent {
           layout.alignContent = yogaTranslator.translate(alignContent)
        }
        
        if let flexGrow = flex.grow {
           layout.flexGrow = CGFloat(flexGrow)
        }
        
        if let flexShrink = flex.shrink {
           layout.flexShrink = CGFloat(flexShrink)
        }
        
        if let display = flex.display {
           layout.display = yogaTranslator.translate(display)
        }
        
    }
    
    private func applyAtributes(from flex: Flex, to layout: YGLayout) {
        setWidth(flex.size?.width, to: layout)
        setHeight(flex.size?.height, to: layout)
        setMaxWidth(flex.size?.maxWidth, to: layout)
        setMaxHeight(flex.size?.maxHeight, to: layout)
        setMinWidth(flex.size?.minWidth, to: layout)
        setMinHeight(flex.size?.minHeight, to: layout)
        setBasis(flex.basis, to: layout)
        setAspectRatio(flex.size?.aspectRatio, to: layout)
        setMargin(flex.margin, to: layout)
        setPadding(flex.padding, to: layout)
        setPosition(flex.position, to: layout)
    }
    
    // MARK: - Flex Layout Methods
    
    private func setWidth(_ width: UnitValue?, to layout: YGLayout) {
        if let width = width {
            layout.width = yogaTranslator.translate(width)
        }
    }
    
    private func setHeight(_ height: UnitValue?, to layout: YGLayout) {
        if let height = height {
            layout.height = yogaTranslator.translate(height)
        }
    }
    
    private func setMaxWidth(_ maxWidth: UnitValue?, to layout: YGLayout) {
        if let maxWidth = maxWidth {
            layout.maxWidth = yogaTranslator.translate(maxWidth)
        }
    }
    
    private func setMaxHeight(_ maxHeight: UnitValue?, to layout: YGLayout) {
        if let maxHeight = maxHeight {
            layout.maxHeight = yogaTranslator.translate(maxHeight)
        }
    }
    
    private func setMinWidth(_ minWidth: UnitValue?, to layout: YGLayout) {
        if let minWidth = minWidth {
            layout.minWidth = yogaTranslator.translate(minWidth)
        }
    }
    
    private func setMinHeight(_ minHeight: UnitValue?, to layout: YGLayout) {
        if let minHeight = minHeight {
            layout.minHeight = yogaTranslator.translate(minHeight)
        }
    }
    
    private func setBasis(_ basis: UnitValue?, to layout: YGLayout) {
        if let basis = basis {
            layout.flexBasis = yogaTranslator.translate(basis)
        } else {
            layout.flexBasis = YGValue(value: 0.0, unit: .auto) // TODO: Check this
        }
    }
    
    private func setAspectRatio(_ aspectRatio: Double?, to layout: YGLayout) {
        if let aspectRatio = aspectRatio {
            layout.aspectRatio = CGFloat(aspectRatio)
        }
    }
    
    private func setMargin(_ margin: Flex.EdgeValue?, to layout: YGLayout) {
        
        if let all = margin?.all {
            layout.margin = yogaTranslator.translate(all)
            return
        }
        
        if let left = margin?.left {
            layout.marginLeft = yogaTranslator.translate(left)
        }
        
        if let top = margin?.top {
            layout.marginTop = yogaTranslator.translate(top)
        }
        
        if let right = margin?.right {
            layout.marginRight = yogaTranslator.translate(right)
        }
        
        if let bottom = margin?.bottom {
            layout.marginBottom = yogaTranslator.translate(bottom)
        }
        
        if let start = margin?.start {
            layout.marginStart = yogaTranslator.translate(start)
        }
        
        if let end = margin?.end {
            layout.marginEnd = yogaTranslator.translate(end)
        }
        
        if let horizontal = margin?.horizontal {
            layout.marginHorizontal = yogaTranslator.translate(horizontal)
        }
        
        if let vertical = margin?.vertical {
            layout.marginVertical = yogaTranslator.translate(vertical)
        }
        
    }
    
    private func setPadding(_ padding: Flex.EdgeValue?, to layout: YGLayout) {
        
        if let all = padding?.all {
            layout.padding = yogaTranslator.translate(all)
            return
        }
        
        if let left = padding?.left {
            layout.paddingLeft = yogaTranslator.translate(left)
        }
        
        if let top = padding?.top {
            layout.paddingTop = yogaTranslator.translate(top)
        }
        
        if let right = padding?.right {
            layout.paddingRight = yogaTranslator.translate(right)
        }
        
        if let bottom = padding?.bottom {
            layout.paddingBottom = yogaTranslator.translate(bottom)
        }
        
        if let start = padding?.start {
            layout.paddingStart = yogaTranslator.translate(start)
        }
        
        if let end = padding?.end {
            layout.paddingEnd = yogaTranslator.translate(end)
        }
        
        if let horizontal = padding?.horizontal {
            layout.paddingHorizontal = yogaTranslator.translate(horizontal)
        }
        
        if let vertical = padding?.vertical {
            layout.paddingVertical = yogaTranslator.translate(vertical)
        }
        
    }
    
    private func setPosition(_ position: Flex.Position?, to layout: YGLayout) {
        if let position = position {
            layout.position = yogaTranslator.translate(position)
        }
    }
    
}
