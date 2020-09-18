//
//  Surv1ViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/18/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Surv1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "1 of 4 questions"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func surv1TrueHandler(_ sender: Any) {
        submitQuiz1(setSurveyStatus: 1)
        goToNext()
    }
    
    
    @IBAction func surv1FalseHandler(_ sender: Any) {
        submitQuiz1(setSurveyStatus: 0)
        goToNext()
    }
    
    
    func goToNext(){ //navigate without navigation controll

          let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
           guard let surveyTwoVC = mianStorybord.instantiateViewController(withIdentifier: "survey2VC") as?
               Surv2ViewController else{
                   return
           }

           surveyTwoVC.modalPresentationStyle = .fullScreen
           self.present(surveyTwoVC, animated: true, completion: nil)

      }
      
      

      
    func submitQuiz1(setSurveyStatus surveyStatus:Int){
      
      let values = [
        "quiz1":surveyStatus
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
