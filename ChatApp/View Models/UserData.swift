//
//  UserData.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 30/11/21.
//

import Foundation

struct UserData: Codable {

    var username: String
    var email: String
    var profileURL: String
    var uid: String

    var dictionary: [String: Any] {
        return [
            "username": username,
            "email": email,
            "profileURL": profileURL,
            "uid": uid
        ]
    }
}
