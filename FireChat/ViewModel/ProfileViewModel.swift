//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by Stephen Learmonth on 18/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import UIKit

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    
    var description: String {
        switch self {
        case .accountInfo:
            return "Account Info"
        case .settings:
            return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo:
            return "person.circle"
        case .settings:
            return "gear"
        }
    }
}
