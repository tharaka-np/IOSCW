//
//  UpdatesViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/17/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UpdatesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Updates"
        // Do any additional setup after loading the view.
        print("Came here..")
        checkAlreadyLogedIn()
    }
    
    
    @IBAction func goToSurveyHandler(_ sender: Any) {
        
        let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
        guard let surveyOneVC = mianStorybord.instantiateViewController(withIdentifier: "survey1VC") as?
            Surv1ViewController else{
                return
        }

        surveyOneVC.modalPresentationStyle = .fullScreen
        self.present(surveyOneVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func checkAlreadyLogedIn(){
        print("Inside function")
        if(Auth.auth().currentUser?.uid == nil) {
            
            print("DEBUG: User not logged in..")
            DispatchQueue.main.async {
                
                        
                let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
                guard let signInVC = mianStorybord.instantiateViewController(withIdentifier: "LoginVC") as?
                    LoginViewController else{
                        return
                }
                
                let navigation = UINavigationController(rootViewController: signInVC)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation,animated: true,completion: nil)

            }
            
        } else {
            print("DEBUG: User is logged in..")
        }
        
    }

}
