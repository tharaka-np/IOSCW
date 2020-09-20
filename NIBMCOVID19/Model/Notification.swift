//
//  Notification.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

struct notification {
    
    let title: String?
    let description: String?
    let syncDateTime: String?
    let uid: String?

    
    init(title:String?, description:String? , syncDateTime:String?, uid:String? ) {
        self.title = title;
        self.description = description;
        self.syncDateTime = syncDateTime;
        self.uid = uid;
    }
}
