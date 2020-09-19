//
//  CreateNotificationViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

class CreateNotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "New notification"
                
        // Do any additional setup after loading the view.
    }
    
    let notificationArray = [
        "uid": Service.shared.getUserUid(),
        "description":"TEST1",
        "syncDateTime":DatesHelper.shared.getNowDate(Date())
        ]as [String:Any]
    
    
    @IBAction func notificationHandler(_ sender: Any) {
        
        Service.shared.addNewNotification(notificationArray)
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
