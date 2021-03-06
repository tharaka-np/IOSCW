//
//  Surv2ViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/18/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Surv2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "2 of 4 questions"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func surv2TrueHandler(_ sender: Any) {
        submitQuiz2(setSurveyStatus: 1)
        goToNext()
    }
    
    
    
    @IBAction func surv2FalseHandler(_ sender: Any) {
        submitQuiz2(setSurveyStatus: 0)
        goToNext()
    }
    
    func goToNext(){ //navigate without navigation controll

          let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
           guard let surveyTwoVC = mianStorybord.instantiateViewController(withIdentifier: "survey3VC") as?
               Surv3ViewController else{
                   return
           }

           surveyTwoVC.modalPresentationStyle = .fullScreen
           self.present(surveyTwoVC, animated: true, completion: nil)

      }
      
      

      
    func submitQuiz2(setSurveyStatus surveyStatus:Int){
      
      let values = [
        "quiz2":surveyStatus,
        "syncDateTime": DatesHelper.shared.getNowDate(Date())
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
