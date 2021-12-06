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
            configure()
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
    
    
    let chatImage: UIImageView = {
        let chatimage = UIImageView()
        
        chatimage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.clipsToBounds = true
        chatimage.contentMode = .scaleAspectFill
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
    
    
    func configure(){
        leftConstraint =   messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 5)
        rightConstraint =  messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -5)
        
        messageContent.text = messageItem?.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: messageItem!.time)
        addSubview(messageContainer)
        messageContainer.addSubview(messageContent)
        messageContainer.addSubview(time)
        messageContainer.widthAnchor.constraint(equalToConstant: 250).priority = UILayoutPriority(999)
        rightConstraint?.priority = UILayoutPriority(997)
        
        NSLayoutConstraint.activate([
            
            messageContainer.widthAnchor.constraint(equalToConstant: 250),
            messageContainer.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageContent.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 5),
            messageContent.leftAnchor.constraint(equalTo: messageContainer.leftAnchor),
            time.topAnchor.constraint(equalTo: messageContent.bottomAnchor),
            time.leftAnchor.constraint(equalTo: messageContent.rightAnchor),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor),
            time.rightAnchor.constraint(equalTo: messageContainer.rightAnchor)
        ])
        
        if messageItem?.sender == DatabaseManager.shared.getUID(){
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = .systemMint
        }else{
            leftConstraint?.isActive =  true
            rightConstraint?.isActive = false
            messageContainer.backgroundColor = .systemGray2
            
        }
    }
    
    
}
