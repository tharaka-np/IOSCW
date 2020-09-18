//
//  ViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/13/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapButton() {
        let vc = storyboard?.instantiateViewController(identifier: "signup_vc") as!SignUpViewController
        present(vc, animated:true)
    }
}

