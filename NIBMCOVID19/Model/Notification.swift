//
//  Notification.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

struct notification {
    
    let description: String?
    let syncDateTime: String?
    let uid: String?

    
    init(description:String? , syncDateTime:String?, uid:String? ) {
        self.description = description;
        self.syncDateTime = syncDateTime;
        self.uid = uid;
    }
}
