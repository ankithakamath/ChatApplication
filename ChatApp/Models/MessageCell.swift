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
                var isSender = true
                guard let uid = DatabaseManager.shared.getUID() else { return }
                if uid != messageItem?.sender {
                    isSender = false
                }
                configure()
            }
        }
    
    let messageContent :UILabel = {
        let message = UILabel()
        message.textColor = .label
        message.backgroundColor = .systemGreen
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
        let messageConatiner = UIView()
        messageConatiner.backgroundColor = .systemGreen
        messageConatiner.layer.cornerRadius = 10
        messageConatiner.translatesAutoresizingMaskIntoConstraints = false
        return messageConatiner
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
        leftConstraint =   messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 10)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -10)
        
        addSubview(messageContainer)
        messageContent.text = messageItem?.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        messageContent.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        messageContainer.addSubview(messageContent)
        messageContainer.addSubview(time)
        
        if messageItem!.sender == uid  {
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = .systemGreen
            
        }
        else{
            leftConstraint?.isActive =  true
            rightConstraint?.isActive = false
            messageContainer.backgroundColor = .systemGray
            messageContent.backgroundColor = .systemGray
        }
     
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
}
