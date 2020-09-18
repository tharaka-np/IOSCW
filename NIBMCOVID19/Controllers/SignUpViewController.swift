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
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
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
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        print("Ok")
        
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
            print("----------------------------------------")
            if let error = error {
                print("Faild to register user with error \(error)")
                return
            }
            guard let uid = result?.user.uid else { return }

            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                print("Successfuly Registerd and save data..")
            }

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

