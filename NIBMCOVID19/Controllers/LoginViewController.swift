//
//  LoginViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/18/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPwd: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginController(_ sender: Any) {
        print("Try to login");
        
        guard let mail = loginEmail.text else{return}
        guard let pwd = loginPwd.text else{return}
        
        Auth.auth().signIn(withEmail: mail, password: pwd) { (result, error) in
            if let error = error {
                print("Faild to login user with error \(error)")
                return
            }
            
            print("Login success");
            //self.dismiss(animated: true, completion: nil)
        }
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
