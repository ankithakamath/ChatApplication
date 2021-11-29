//
//  MessageModel.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 21/11/21.
//

import Foundation

struct MessageModel {
    var sender: String
    var message: String
    var time: Date
    var dateString: String?
    
    var dictionary: [String: Any] {
        return [
            "sender": sender,
            "message": message,
            "time": dateString!,
          
        ]
    }
}
