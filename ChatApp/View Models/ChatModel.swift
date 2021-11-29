//
//  ChatModel.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 21/11/21.
//

import Foundation

struct ChatModel {
    var users: [User]
    var lastMessage: MessageModel?
    var messagesArray: [MessageModel]?
    var otherUserIndex: Int?
    var chatId: String?
}
