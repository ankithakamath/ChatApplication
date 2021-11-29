//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 16/11/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManager {
    
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    let databaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    
    
    
    public func userAlreadyExists( email: String, Completion: @escaping ((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else {
                Completion(false)
                return
            }
            Completion(true)
        })
    }
    
    func getUser(uid: String, completion: @escaping(User) -> Void) {
        database.child("Users").child(uid).observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let email = dictionary["email"] as! String
                let username = dictionary["username"] as! String
                let profileURL = dictionary["profileURL"] as! String
                let uid = dictionary["uid"] as! String
                
                let user = User(username: username, email: email, profileURL: profileURL, uid: uid)
                completion(user)
            }
        }
    }
    
    func getAllUsers(uid: String, completion: @escaping([User]) -> Void) {
        print("useruseruseruseruser")
        
        var users = [User]()
        
        database.child("Users").observe(.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
                //                print(result)
                for userid in result.keys {
                    if userid == uid {
                        continue
                    }
                    let userData = result[userid] as! [String: Any]
                    
                    let email = userData["email"] as! String
                    let username = userData["username"] as! String
                    let uid = userData["uid"] as! String
                    let profileURL = userData["profileURL"] as! String
                    let user = User(username: username, email: email, profileURL: profileURL, uid: uid)
                    users.append(user)
                }
                completion(users)
            }
        }
        
    }
    
    
    
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    public func onLogout() ->Bool{
        
        do {
            try Auth.auth().signOut()
            return true
        }catch{
            return false
        }
    }
    
    func addMessage(chat: ChatModel, id: String, messageContent:[MessageModel]) {
        
        var currentChat = chat
        
        let dateString = databaseDateFormatter.string(from: currentChat.lastMessage!.time)
        currentChat.lastMessage?.dateString = dateString
        
        let lastMessageDictionary = currentChat.lastMessage?.dictionary
        var messagesDictionary: [[String: Any]] = []
        
        for var message in messageContent {
            let dateString = databaseDateFormatter.string(from: message.time)
            message.dateString = dateString
            messagesDictionary.append(message.dictionary)
        }
        
        let finalDictionary = ["lastMessage": lastMessageDictionary!,
                               "messagesArray": messagesDictionary] as [String : Any]
        
        database.child("Chats").child(id).updateChildValues(finalDictionary)
    }
    
    
    func addUser(user: User) {
        database.child("Users").child(user.uid).setValue(user.dictionary)
    }
    
    func fetchMessages(chatId: String, completion: @escaping([MessageModel]) -> Void) {
        database.child("Chats").child("\(chatId)/messagesArray").observe(.value) { [self] snapshot in
            var resultArray: [MessageModel] = []
            
            if let result = snapshot.value as? [[String: Any]] {
                //
                for message in result {
                    //
                    let sender = message["sender"] as! String
                    let messageContent = message["message"] as! String
                    let timeString = message["time"] as! String
                    
                    let time = databaseDateFormatter.date(from: timeString)
                    resultArray.append(MessageModel(sender: sender, message: messageContent, time: time!))
                }
                
                completion(resultArray)
            }
        }
    }
    
    func addChat(user1: User, user2: User, id: String) {
        var userDictionary: [[String: Any]] = []
        
        userDictionary.append(user1.dictionary)
        userDictionary.append(user2.dictionary)
        let finalDic = ["users" : userDictionary]
        
        database.child("Chats").child(id).setValue(finalDic)
    }
    
    
    func fetchChats(uid: String, completion: @escaping([ChatModel]) -> Void) {
        
        database.child("Chats").observe(.value) { [self] snapshot in
            var chats = [ChatModel]()
            print("---------------------------")
            if let result = snapshot.value as? [String: [String: Any]] {
                //                print(result)
                for key in result.keys {
                    //                   print(key)
                    let value = result[key]!
                    var messagesArray: [MessageModel] = []
                    var lastMessage: MessageModel?
                    
                    let users = value["users"] as! [[String: Any]]
                    let lastMessageArray = value["lastMessage"] as? [String: Any]
                    let messageArray = value["messagesArray"] as? [[String: Any]]
                    //                    print(users)
                    if lastMessageArray != nil {
                        for messageItem in messageArray! {
                            let sender = messageItem["sender"] as! String
                            let message = messageItem["message"] as! String
                            let timeString = messageItem["time"] as! String
                         
                            
                            let time = databaseDateFormatter.date(from: timeString)
                            
                            let currentMessage = MessageModel(sender: sender, message: message, time: time!)
                            
                            messagesArray.append(currentMessage)
                        }
                        
                        let sender = lastMessageArray!["sender"] as! String
                        let message = lastMessageArray!["message"] as! String
                        let timeString = lastMessageArray!["time"] as! String
                      
                        
                        let time = databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = MessageModel(sender: sender, message:message, time: time!)
                        
                    } else {
                        messagesArray = []
                        lastMessage = nil
                    }
                    
                    let user1 = users[0]
                    let user2 = users[1]
                    
                    let email1 = user1["email"] as! String
                    let username1 = user1["username"] as! String
                    let uid1 = user1["uid"] as! String
                    let profileURL1 = user1["profileURL"] as! String
                    
                    let firstUser = User(username: username1, email: email1, profileURL: profileURL1, uid: uid1)
                    
                    let email2 = user2["email"] as! String
                    let username2 = user2["username"] as! String
                    let uid2 = user2["uid"] as! String
                    let profileURL2 = user2["profileURL"] as! String
                    
                    let secondUser = User(username: username2, email: email2, profileURL: profileURL2, uid: uid2)
                    
                    var otherUser: Int
                    
                    if uid1 == uid {
                        otherUser = 1
                    } else {
                        otherUser = 0
                    }
                    let id = key
                    let chat = ChatModel(users: [firstUser, secondUser], lastMessage: lastMessage, messagesArray: messagesArray, otherUserIndex: otherUser,chatId: id)
                    
                    if firstUser.uid == uid || secondUser.uid == uid {
                        chats.append(chat)
                    }
                    
                    print(chat)
                    
                }
                completion(chats)
            }
        }
    }
    
    func createMessageObject(dictionary: [String: Any]) -> MessageModel {
        let sender = dictionary["sender"] as! String
        let message = dictionary["message"] as! String
        let timeString = dictionary["time"] as! String
        
        let time = databaseDateFormatter.date(from: timeString)
        
        return MessageModel(sender: sender, message: message, time: time!)
    }
}





struct User: Codable {
    
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

//struct ChatAppUser {
//    let firstName: String
//    let lastName: String
//    let emailAddress: String
//
//    var safeEmail: String {
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//
//    }
//
//    var profilePictureFileName: String {
//        //ankitha99-gmail-com_profile_picture.png
//        return "\(safeEmail)_profile_picture.png"
//    }
//
//}
