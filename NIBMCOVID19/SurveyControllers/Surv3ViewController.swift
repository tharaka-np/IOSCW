//
//  Surv3ViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/18/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Surv3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "3 of 4 questions"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func surv3TrueHandler(_ sender: Any) {
        submitQuiz3(setSurveyStatus: 1)
        goToNext()
    }
    
    
    
    @IBAction func surv3FalseHandler(_ sender: Any) {
        submitQuiz3(setSurveyStatus: 0)
        goToNext()
    }
    
    func goToNext(){ //navigate without navigation controll

          let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
           guard let surveyTwoVC = mianStorybord.instantiateViewController(withIdentifier: "survey4VC") as?
               Surv4ViewController else{
                   return
           }

           surveyTwoVC.modalPresentationStyle = .fullScreen
           self.present(surveyTwoVC, animated: true, completion: nil)

      }
      
      

      
    func submitQuiz3(setSurveyStatus surveyStatus:Int){
      
      let values = [
        "quiz3":surveyStatus
            ]as [String : Any]
    
          
      let user = Auth.auth().currentUser
      guard let uid = user?.uid else { return }

      Database.database().reference().child("survey").child(uid).updateChildValues(values) { (error, ref) in
          print("Successfuly save data..")
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
