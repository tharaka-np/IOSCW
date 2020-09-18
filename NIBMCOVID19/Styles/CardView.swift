//
//  CardView.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/17/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

@IBDesignable  class CardView: UIView {

    @IBInspectable var cornerradius : CGFloat = 2
    
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    
    @IBInspectable var shadowOffSetHeight : CGFloat = 5
    
    @IBInspectable var shadowColor : UIColor = UIColor.black
    
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerradius
        
        layer.shadowColor = shadowColor.cgColor
        
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
    }

}
