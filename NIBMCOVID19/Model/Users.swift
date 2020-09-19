//
//  Users.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import Foundation

struct UserDetails {
    
    var accountType: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var indexNo: String?
    var imageUrl: String?
    
    init(accountType: String?, email: String?, firstName: String?, lastName: String?, password: String?, indexNo: String?, imageUrl: String?) {
        self.accountType = accountType
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.indexNo = indexNo
        self.imageUrl = imageUrl
    }
}

