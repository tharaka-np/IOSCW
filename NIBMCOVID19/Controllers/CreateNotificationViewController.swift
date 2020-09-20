//
//  CreateNotificationViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

class CreateNotificationViewController: UIViewController {
    
    @IBOutlet weak var msgHeading: UITextField!
    @IBOutlet weak var msgBody: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "New notification"
                
        // Do any additional setup after loading the view.
    }
    
    @IBAction func notificationSend(_ sender: Any) {
        
        guard let head = msgHeading.text else {return}
        guard let body = msgBody.text else {return}
        
        let notificationArray = [
            "uid": Service.shared.getUserUid(),
            "title": head,
            "description": body,
            "syncDateTime":DatesHelper.shared.getNowDate(Date())
            ]as [String:Any]
        
        Service.shared.addNewNotification(notificationArray)
        
        // create the alert
        let alert = UIAlertController(title: "Success", message: "Notification successfully created.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
