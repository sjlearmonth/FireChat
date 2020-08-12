//
//  Service.swift
//  FireChat
//
//  Created by Stephen Learmonth on 12/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import Firebase

struct Service {
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let documentDictionary = document.data()
                let user = User(dictionary: documentDictionary)
                users.append(user)
            })
            completion(users)
        }
        
    }
}
