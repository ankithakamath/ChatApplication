//
//  MessageCell.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 21/11/21.
//

import Foundation

import UIKit
import FirebaseAuth

class MessageCell: UITableViewCell {
    
    static let reuseIdentifier = "messageCell"
    var leftConstraint : NSLayoutConstraint?
    var rightConstraint :NSLayoutConstraint?
    let uid = Auth.auth().currentUser?.uid
    var messageItem: Message? {
            didSet {
                var isSender : Bool
                guard let uid = DatabaseManager.shared.getUID() else { return }
                if uid != messageItem?.sender {
                    isSender = false
                }else{
                    isSender = true
                }
                if messageItem!.imageChat! == "" {
                             configure(isSender: isSender)
                         } else {
                             configureChatImage(isSender: isSender)
                         }
                     }
                 }
    
    let messageContent :UILabel = {
        let message = UILabel()
        message.textColor = .label
        message.numberOfLines = 0
        message.translatesAutoresizingMaskIntoConstraints =  false
        return message
    }()
    
    let time: UILabel = {
        let time = UILabel()
        time.textColor = .white
        time.translatesAutoresizingMaskIntoConstraints =  false
        return time
    }()
    
    let messageContainer :UIView = {
        let messageContainer = UIView()
        messageContainer.layer.cornerRadius = 10
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        return messageContainer
    }()
    
//    let chatContainer :UIView = {
//        let chatContainer = UIView()
//        chatContainer.backgroundColor = .systemGreen
//        chatContainer.layer.cornerRadius = 10
//        chatContainer.translatesAutoresizingMaskIntoConstraints = false
//        return chatContainer
//    }()
    
    let chatImage: UIImageView = {
        let chatimage = UIImageView()
        chatimage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.clipsToBounds = true
        chatimage.contentMode = .scaleAspectFit
        chatimage.translatesAutoresizingMaskIntoConstraints = false
        return chatimage
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure(isSender: Bool){
        leftConstraint =   messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 10)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -10)
        
        
        messageContent.text = messageItem?.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        messageContent.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        addSubview(messageContainer)
        messageContainer.addSubview(messageContent)
        messageContainer.addSubview(time)
        
//        if messageItem!.sender == uid  {
//            leftConstraint?.isActive =  false
//            rightConstraint?.isActive = true
//            messageContainer.backgroundColor = .systemGreen
//
//        }
//        else{
//            leftConstraint?.isActive =  true
//            rightConstraint?.isActive = false
//            messageContainer.backgroundColor = .systemGray
//            messageContent.backgroundColor = .systemGray
//        }
        if isSender{
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = .systemGreen
        }else{
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = .systemGray
            
        }
//        messageContainer.backgroundColor = isSender ? .systemGreen : .systemGray
        NSLayoutConstraint.activate([
            messageContainer.widthAnchor.constraint(equalToConstant: 300),
            messageContainer.topAnchor.constraint(equalTo:topAnchor,constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -5),
            
            messageContent.leftAnchor.constraint(equalTo:messageContainer.leftAnchor,constant: 10),
            messageContent.topAnchor.constraint(equalTo:messageContainer.topAnchor,constant: 10),
            time.rightAnchor.constraint(equalTo:messageContainer.rightAnchor,constant: -5),
            time.topAnchor.constraint(equalTo: messageContent.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: 0),
            time.widthAnchor.constraint(equalToConstant: 80),
            messageContent.rightAnchor.constraint(equalTo:time.leftAnchor,constant:-10),
        ])
    }
    
    
        func configureChatImage(isSender: Bool){
            Storagemanager.shared.downloadImageWithPath(path: messageItem!.imageChat!, completion: { image in
                       DispatchQueue.main.async {
                           self.chatImage.image = image
                       }
                   })
            leftConstraint =   messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 10)
            rightConstraint = messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -10)
            addSubview(messageContainer)
            messageContent.text = messageItem?.content
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:a"
            messageContent.text = messageItem!.content
            time.text = dateFormatter.string(from: messageItem!.time)
            messageContainer.addSubview(messageContent)
            messageContainer.addSubview(chatImage)
            messageContainer.addSubview(time)
            if isSender{
                leftConstraint?.isActive =  false
                rightConstraint?.isActive = true
                messageContainer.backgroundColor = .systemGreen
            }else{
                leftConstraint?.isActive =  true
                rightConstraint?.isActive = false
                messageContainer.backgroundColor = .systemGray
            }
            NSLayoutConstraint.activate([
                messageContainer.widthAnchor.constraint(equalTo: chatImage.widthAnchor, constant: 10),
                messageContainer.topAnchor.constraint(equalTo:topAnchor,constant: 5),
                messageContainer.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -5),
                chatImage.topAnchor.constraint(equalTo: messageContainer.topAnchor,constant: 5),
                chatImage.centerXAnchor.constraint(equalTo: messageContainer.centerXAnchor, constant: 0),
                //time.centerXAnchor.constraint(equalTo: centerXAnchor),
                time.rightAnchor.constraint(equalTo:messageContainer.rightAnchor,constant: -5),
                time.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 5),
                time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -5),
                time.widthAnchor.constraint(equalToConstant: 80)
                
            ])
            
            
        }
    
}
