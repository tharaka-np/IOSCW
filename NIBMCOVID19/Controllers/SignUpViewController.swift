//
//  SignUpViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/16/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var userRole: UITextField!
    var seletedUser:String?
    var listOfUsers = ["Staff", "Student"]
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var selectedUserRole: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAndSetupPickerView()
        self.dissmissAndClosePicker()
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let long = location.coordinate.latitude
            let lat = location.coordinate.longitude
            
            let values = [
            "longitude":long,
            "latitude":lat,
            "uid": Service.shared.getUserUid()
            ] as [String : Any]
            
            Service.shared.updateUserCordinates(values)
            
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }
    
    func createAndSetupPickerView(){
        
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        self.userRole.inputView = pickerview
        
    }
    
    
    func dissmissAndClosePicker(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.userRole.inputAccessoryView = toolBar

    }
    
    @objc func dismissAction(){
        self.view.endEditing((true))
    }
    
    @IBAction func handleSignUp(_ sender: Any) {
        
        guard let fname = firstName.text else {return}
        guard let mail = email.text else {return}
        guard let pwd = password.text else {return}
        guard let lname = lastName.text else {return}
        guard let role = selectedUserRole.text else {return}


        let values = [
        "firstName":fname,
        "lastName":lname,
        "email": mail,
        "password":pwd,
        "accountType": role
        ] as [String : Any]

        Auth.auth().createUser(withEmail: mail, password: pwd) { (result, error) in
            if let error = error {
                print("Faild to register user with error \(error)")
                return
            }
            guard let uid = result?.user.uid else { return }

            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
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
            }

        }
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listOfUsers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listOfUsers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.seletedUser = self.listOfUsers[row]
        self.userRole.text = self.seletedUser
    }
}

