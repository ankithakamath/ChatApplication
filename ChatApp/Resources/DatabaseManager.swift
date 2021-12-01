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
    
    func addUser(user: UserData) {
        database.child("Users").child(user.uid).setValue(user.dictionary)
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
    
    
    
    
    func getUser(uid: String, completion: @escaping(UserData) -> Void) {
        database.child("Users").child(uid).observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let email = dictionary["email"] as! String
                let username = dictionary["username"] as! String
                let profileURL = dictionary["profileURL"] as! String
                let uid = dictionary["uid"] as! String
                
                let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                completion(user)
            }
        }
    }
    
    func getAllUsers(completion: @escaping([UserData]) -> Void) {
        print("useruseruseruseruser")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var users = [UserData]()
        
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
                    let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                    users.append(user)
                }
                completion(users)
            }
        }
        
    }
    
    func addChat(user1: UserData, user2: UserData, id: String) {
        var userDictionary: [[String: Any]] = []
        
        userDictionary.append(user1.dictionary)
        userDictionary.append(user2.dictionary)
        let finalDic = ["users" : userDictionary]
        
        database.child("Chats").child(id).setValue(finalDic)
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

    
    func addMessage(messages: [Message], lastMessage: Message, id: String) {
        var lastMessageItem = lastMessage
               
               let dateString = databaseDateFormatter.string(from: lastMessageItem.time)
               lastMessageItem.dateString = dateString
               
               let lastMessageDictionary = lastMessageItem.dictionary
               var messagesDictionary: [[String: Any]] = []
               
               for var message in messages {
                   let dateString = databaseDateFormatter.string(from: message.time)
                   message.dateString = dateString
                   messagesDictionary.append(message.dictionary)
               }
               let finalDictionary = ["lastMessage": lastMessageDictionary]
               database.child("Chats").child(id).updateChildValues(finalDictionary)
               database.child("Chats").child(id).child("messages").childByAutoId().setValue(lastMessageDictionary)
           }
           
          
    
    
    
    
    func fetchMessages(chatId: String, completion: @escaping([Message]) -> Void) {
        database.child("Chats").child("\(chatId)/messages").observe(.value) { [self] snapshot in
                  var resultArray: [Message] = []
                  print("Messages\(snapshot.value)")
                  if let result = snapshot.value as? [String: [String: Any]] {
                      let sortedKeyArray = result.keys.sorted()
                      for id in sortedKeyArray {
      
                          let message = result[id]!
                          resultArray.append(createMessageObject(dictionary: message , id: id))
                      }
                      
                      completion(resultArray)
                  }
              }
          }
    
    func createMessageObject(dictionary: [String: Any],id: String) -> Message{
        
        let sender = dictionary["sender"] as! String
        let content = dictionary["content"] as! String
        let timeString = dictionary["time"] as! String
        let seen = dictionary["seen"] as! Bool
        
        let time = databaseDateFormatter.date(from: timeString)
        
        return Message(sender: sender, content: content, time: time!, seen: seen, id: id)
    }
    
    func getUID() -> String? {
           return Auth.auth().currentUser?.uid
       }
    
    
    func fetchChats(uid: String, completion: @escaping([Chats]) -> Void) {
        
        database.child("Chats").observe(.value) { snapshot in
            var chats = [Chats]()
            if let result = snapshot.value as? [String: [String: Any]] {
                
                for key in result.keys {
                    //                   print(keys)
                    let value = result[key]!
                    var messagesArray: [Message] = []
                    var lastMessage: Message?
                    
                    let users = value["users"] as! [[String: Any]]
                    let lastMessageDictionary = value["lastMessage"] as? [String: Any]
                    let messagesDictionary = value["messages"] as? [[String: Any]]
                    //                    print(users)
                    if lastMessageDictionary != nil {
                        
                        let sender = lastMessageDictionary!["sender"] as! String
                        let content = lastMessageDictionary!["content"] as? String
                        let timeString = lastMessageDictionary!["time"] as! String
                        let seen = lastMessageDictionary!["seen"] as? Bool
                     
                        let time = self.databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = Message(sender: sender, content: content!, time: time!, seen: seen!)
                        
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
                    
                    let firstUser = UserData(username: username1, email: email1, profileURL: profileURL1, uid: uid1)
                    
                    let email2 = user2["email"] as! String
                    let username2 = user2["username"] as! String
                    let uid2 = user2["uid"] as! String
                    let profileURL2 = user2["profileURL"] as! String
                    
                    let secondUser = UserData(username: username2, email: email2, profileURL: profileURL2, uid: uid2)
                    
                    var otherUser: Int
                    
                    if uid1 == uid {
                        otherUser = 1
                    } else {
                        otherUser = 0
                    }
                    let id = key
                    
                    let chat = Chats(chatId: id, users: [firstUser, secondUser], lastMessage: lastMessage, messages: [], otherUser: otherUser)
                    
                    if firstUser.uid == uid || secondUser.uid == uid {
                        chats.append(chat)
                    }
                }
                let sortedChats = chats.sorted()
                completion(sortedChats)
            }
        }
    }
 
}
