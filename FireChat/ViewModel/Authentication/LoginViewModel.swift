//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Stephen Learmonth on 04/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?

    var formIsValid: Bool {
        return !(email?.isEmpty ?? true) &&
               !(password?.isEmpty ?? true)
    }
}
