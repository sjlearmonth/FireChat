//
//  User.swift
//  FireChat
//
//  Created by Stephen Learmonth on 12/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}

