//
//  ConversationViewModel.swift
//  FireChat
//
//  Created by Stephen Learmonth on 17/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import UIKit

struct ConversationViewModel {
    
    // MARK: - Properties
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.chatPartner.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
