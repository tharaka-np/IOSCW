//
//  RoundedImageView.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

extension UIImageView{
    func roundImageView(){
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.0227817148, green: 0.215121001, blue: 0.2304691374, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
