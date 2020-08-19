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
        
        USERS_COLLECTION_REF.getDocuments { snapshot, error in
            
            guard var chatPartners = snapshot?.documents.map( { User(dictionary: $0.data()) }) else { return }
            
            if let loggedInUserIndex = chatPartners.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid}) {
                chatPartners.remove(at: loggedInUserIndex)
            }
            
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
        print("DEBUG: uid = \(uid)")
        let query = MESSAGES_COLLECTION_REF.document(uid).collection("recent-messages").order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach( {change in
                print("DEBUG: Got here 1")
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchChatPartner(withUid: message.chatPartnerId) { chatPartner in
                    let conversation = Conversation(chatPartner: chatPartner, message: message)
                    conversations.append(conversation)
                }
            })
            completion(conversations)
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
