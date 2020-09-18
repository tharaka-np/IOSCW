//
//  ThankyouViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/18/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

class ThankyouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "1 of 4 questions"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func thankyouButtonHandler(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
