//
//  ChatModel.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 21/11/21.
//

import Foundation

struct Chats: Comparable {
    static func == (lhs: Chats, rhs: Chats) -> Bool {
        return true
    }
    
    static func < (lhs: Chats, rhs: Chats) -> Bool {
        guard let lastMessageLHS = lhs.lastMessage else {
            return false
        }
        guard let lastMessageRHS = rhs.lastMessage else {
            return true
        }
        if lastMessageLHS.time < lastMessageRHS.time.addingTimeInterval(10) {
            return false
        } else {
            return true
        }
    }
    
    var chatId: String?
    var users: [UserData]
    var lastMessage: Message?
    var messages: [Message]?
    var otherUser: Int?
    var unSeenCount: Int?
}
