//
//  RadialGradientView.swift
//  FindTheMonkey
//
//  Created by Sang Luu on 9/9/17.
//  Copyright © 2017 Sang Luu. All rights reserved.
//

import UIKit

class RadialGradientView: UIView {
    private let gradientLayer = RadialGradientLayer()
    
    var colors: [UIColor] {
        get {
            return gradientLayer.colors
        }
        set {
            gradientLayer.colors = newValue
        }
    }
    
    var centerGradient: CGPoint{
        get{
            return gradientLayer.centerPoint
        }
        set{
            gradientLayer.centerPoint = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = bounds
    }
}


class RadialGradientLayer: CALayer {
    
    var centerPoint: CGPoint = CGPoint(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    var radius: CGFloat {
        return (bounds.width + bounds.height)/2
    }
    
    var colors: [UIColor] = [UIColor.black, UIColor.lightGray] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cgColors: [CGColor] {
        return colors.map({ (color) -> CGColor in
            return color.cgColor
        })
    }
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            return
        }
        ctx.drawRadialGradient(gradient, startCenter: centerPoint, startRadius: 0.0, endCenter: centerPoint, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
}




