//
//  GradientButton.swift
//  BudgetCards
//
//  Created by Sekhar Simhadri on 09/10/19.
//  Copyright © 2019 Sekhar Simhadri. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    override func awakeFromNib() {
        
        layoutIfNeeded()
        
        let gradientBorder = CAGradientLayer()
        gradientBorder.frame =      bounds
        //Set gradient to be horizontal
        gradientBorder.startPoint = CGPoint(x: 0, y: 0.5)
        gradientBorder.endPoint =   CGPoint(x: 1, y: 0.5)
        gradientBorder.colors =    [#colorLiteral(red: 0.9511950612, green: 0.6081784964, blue: 0.3069793582, alpha: 1).cgColor,#colorLiteral(red: 0.971807301, green: 0.8036563993, blue: 0.6507971883, alpha: 1).cgColor,#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth =     2
        shape.path =          UIBezierPath(rect: bounds).cgPath
        shape.strokeColor =   UIColor.black.cgColor
        shape.fillColor =     UIColor.clear.cgColor
        gradientBorder.mask = shape
        
        layer.addSublayer(gradientBorder)
        
        let gradient =        CAGradientLayer()
        gradient.frame =      bounds
        //Set gradient to be horizontal
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint =   CGPoint(x: 1, y: 0.5)
        gradient.colors =     [#colorLiteral(red: 0.9511950612, green: 0.6081784964, blue: 0.3069793582, alpha: 1).cgColor,#colorLiteral(red: 0.971807301, green: 0.8036563993, blue: 0.6507971883, alpha: 1).cgColor,#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor]
        
        layer.insertSublayer(gradient, at: 0)
        
        let overlayView = UIView(frame: bounds)
        overlayView.isUserInteractionEnabled = false
        overlayView.layer.insertSublayer(gradient, at: 0)
        overlayView.mask = titleLabel
        
        addSubview(overlayView)
    }
}
