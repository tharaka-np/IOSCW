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
import CoreLocation

class UpdatesViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var temparature: UITextField!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    @IBOutlet weak var lastSurveyUpdated: UILabel!
    
    
    @IBOutlet weak var createNotification: CardView!
    
//    var userLastTemp : Temparature
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkAlreadyLogedIn()
        
        if(Auth.auth().currentUser?.uid != nil) {
            getTempInfo()
        }
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 5
            
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {

            let long = location.coordinate.latitude
            let lat = location.coordinate.longitude
            //var temp = 0
            
//            Service.shared.getUserTempById { (userLastTemp) in
//                if !userLastTemp.lastTime!.isEmpty && !userLastTemp.temparature!.isEmpty{
//                    temp = Int(userLastTemp.temparature) ?? 0
//                }
//            }

            let values = [
                "longitude":long,
                "latitude":lat,
                "uid": Service.shared.getUserUid(),
                "temp" : 30,
                "syncDateTime": DatesHelper.shared.getNowDate(Date()),
                
            ] as [String : Any]

            Service.shared.updateUserCordinates(values)

            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }
    
    
    @IBAction func temparatureHandler(_ sender: Any) {
        let userTempInfo = [
                    "temp": Int(temparature.text!) ?? 0,
                    "syncDateTime": DatesHelper.shared.getNowDate(Date()),
                    "uid":Service.shared.getUserUid()
                ]as [String : Any]
        
        Service.shared.updateUserTemp(userTempInfo)
        
        // create the alert
        let alert = UIAlertController(title: "Thank you", message: "Temparature updated successfully.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
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
    
    func checkAlreadyLogedIn(){
        print("Inside function")
        if(Auth.auth().currentUser?.uid == nil) {

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
            Service.shared.getUserTempById { (userLastTemp) in

                print(userLastTemp)

                if !userLastTemp.lastTime!.isEmpty && !String(userLastTemp.temparature!).isEmpty{
                    let Days = DatesHelper.shared.getAgoTime(userLastTemp.lastTime ??  DatesHelper.shared.getNowDate(Date()))

                    self.temparatureLabel.text = String(userLastTemp.temparature!)+" C"
                    self.lastUpdatedLabel.text = ("Last updated on " + Days )
                }else{
                    self.temparatureLabel.text = "0 C"
                    self.lastUpdatedLabel.text = ("Last updated on 0" )
                }

            }
            
            
            Service.shared.getUserLastSurveyById { (userLastSurvey) in

                print(userLastSurvey)

                if !userLastSurvey.lastSurveyTime!.isEmpty {
                    let Days = DatesHelper.shared.getAgoTime(userLastSurvey.lastSurveyTime ??  DatesHelper.shared.getNowDate(Date()))
                    self.lastSurveyUpdated.text = ("Last updated on " + Days )
                }else{
                    self.lastSurveyUpdated.text = ("0" )
                }

            }
            
            Service.shared.getUserById { (userDetails) in
                print(userDetails);
                if userDetails.accountType == "Student" {
                    self.createNotification.isHidden = true
                }
            }
        }

    }
    
    func getTempInfo(){
        Service.shared.getUserTempById { (userLastTemp) in
            
            if !userLastTemp.lastTime!.isEmpty && !String(userLastTemp.temparature!).isEmpty{
                let Days = DatesHelper.shared.getAgoTime(userLastTemp.lastTime ??  DatesHelper.shared.getNowDate(Date()))
                self.temparatureLabel.text = String(userLastTemp.temparature!)+" C"
                self.lastUpdatedLabel.text = ("Last updated on " + Days )
            }else{
                self.temparatureLabel.text = "0 C"
                self.lastUpdatedLabel.text = ("Last updated on 0" )
            }

        }
        
        Service.shared.getUserLastSurveyById { (userLastSurvey) in

            print(userLastSurvey)

            if !userLastSurvey.lastSurveyTime!.isEmpty {
                let Days = DatesHelper.shared.getAgoTime(userLastSurvey.lastSurveyTime ??  DatesHelper.shared.getNowDate(Date()))
                self.lastSurveyUpdated.text = ("Last updated on " + Days )
            }else{
                self.lastSurveyUpdated.text = ("0" )
            }

        }
        
        
    }

}
