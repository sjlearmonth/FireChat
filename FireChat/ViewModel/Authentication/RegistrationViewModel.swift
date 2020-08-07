//
//  RegistrationViewModel.swift
//  FireChat
//
//  Created by Stephen Learmonth on 04/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import UIKit

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var profileImage: UIImage?

    var formIsValid: Bool {
        if let _ = profileImage {
            return !(email?.isEmpty ?? true) &&
                   !(password?.isEmpty ?? true) &&
                   !(fullname?.isEmpty ?? true) &&
                   !(username?.isEmpty ?? true)
        } else {
            return false
        }
    }
}

