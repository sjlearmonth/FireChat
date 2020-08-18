//
//  Service.swift
//  FireChat
//
//  Created by Stephen Learmonth on 12/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import Firebase

struct Service {
    
    static func fetchChatPartners(completion: @escaping ([User]) -> Void) {
        var chatPartners = [User]()
        let currentUid = Auth.auth().currentUser?.uid
        
        USERS_COLLECTION_REF.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let documentDictionary = document.data()
                let chatPartner = User(dictionary: documentDictionary)
                if chatPartner.uid != currentUid {
                    chatPartners.append(chatPartner)
                }
            })
            completion(chatPartners)
        }
    }
    
    static func fetchChatPartner(withUid uid: String, completion: @escaping (User) -> Void) {
        USERS_COLLECTION_REF.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let chatPartner = User(dictionary: dictionary)
            completion(chatPartner)
        }
    }
    
    static func fetchConversations(completion: @escaping ([Conversation]) -> Void ) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = MESSAGES_COLLECTION_REF.document(uid).collection("recent-messages").order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchChatPartner(withUid: message.toId) { chatPartner in
                    let conversation = Conversation(chatPartner: chatPartner, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
            
        }
    }
    
    static func fetchMessages(forUser chatPartner: User, completion: @escaping ([Message]) -> Void) {
       var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = MESSAGES_COLLECTION_REF.document(currentUid).collection(chatPartner.uid).order(by: "timestamp")
        
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
    
    static func uploadMessage(_ message: String, to chatPartner: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text" : message,
                    "fromId" : currentUid,
                    "toId" : chatPartner.uid,
                    "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        MESSAGES_COLLECTION_REF.document(currentUid).collection(chatPartner.uid).addDocument(data: data) { _ in
            MESSAGES_COLLECTION_REF.document(chatPartner.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
        MESSAGES_COLLECTION_REF.document(currentUid).collection("recent-messages").document(chatPartner.uid).setData(data)
            
        MESSAGES_COLLECTION_REF.document(chatPartner.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
    
    
}
