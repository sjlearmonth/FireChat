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
    
    static func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> Void) {
       var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = MESSAGES_COLLECTION_REF.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
        
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text" : message,
                    "fromId" : currentUid,
                    "toId" : user.uid,
                    "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        MESSAGES_COLLECTION_REF.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            MESSAGES_COLLECTION_REF.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
        }
    }
    
    
}
