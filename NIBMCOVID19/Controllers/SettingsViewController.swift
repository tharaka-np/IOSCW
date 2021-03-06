//
//  SettingsViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/17/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MenuItems {
    var menuName: String?
    
    init(name:String){
        self.menuName = name
        
    }
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblMenu: UITableView!
    
    var menuArray = [MenuItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Auth.auth().currentUser?.uid == nil) {
            let createUser = MenuItems(name: "Create new user")
            menuArray.append(createUser)
        }
            
        let aboutUs = MenuItems(name: "About / Contact us")
        menuArray.append(aboutUs)
        
//        let share = MenuItems(name: "Share with friends")
//        menuArray.append(share)
        
//        let surveyResults = MenuItems(name: "Survey Results")
//        menuArray.append(surveyResults)
        
        if(Auth.auth().currentUser?.uid != nil) {
            let profile = MenuItems(name: "Profile")
            menuArray.append(profile)
            
            let logOut = MenuItems(name: "Logout")
            menuArray.append(logOut)
        }
        
        tblMenu.dataSource = self
        tblMenu.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "menuitems")
        
        if cell == nil{
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "menuitems")
        }
        
        cell?.textLabel?.text = menuArray[indexPath.row].menuName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("//////////////////////")
        print([indexPath.row])
        
        var segueIdentifiers = ["aboutusVC"];

        if(Auth.auth().currentUser?.uid == nil) {
            segueIdentifiers.insert("signupVC", at: 0)
        }
        
        if(Auth.auth().currentUser?.uid != nil) {
            segueIdentifiers.insert("userprofileconnect", at: 1)
            segueIdentifiers.insert("logout", at: 2)
        }
        
        if String(segueIdentifiers[indexPath.row]) == "logout" {
            do {
                try Auth.auth().signOut()
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
                
            } catch {
                print ("DEBUG: sign out error")
            }
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)

        }
    }
}
