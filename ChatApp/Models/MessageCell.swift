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
    var currentConstraint: NSLayoutConstraint!
    var receiverConstraint: NSLayoutConstraint!
    var senderConstraint: NSLayoutConstraint!
    var usersList: [UserData]? {
        didSet {
          configureSenderData()
        }
      }
    var messageItem: Message? {
        didSet {
            configure()
        }
    }
    

    let messageContent :UILabel = {
        let message = UILabel()
       message.textColor = UIColor(red: 0.827, green: 0.855, blue: 0.878, alpha: 1)
       message.font = UIFont(name: "PTSans-Regular", size: 21)
        message.numberOfLines = 0
        message.translatesAutoresizingMaskIntoConstraints =  false
        return message
    }()
    
    let time: UILabel = {
        let time = UILabel()
       time.textColor = UIColor(red: 0.561, green: 0.604, blue: 0.627, alpha: 1)
       time.font = UIFont(name: "PTSans-Regular", size: 18)
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
    
    var senderName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "PTSans-Bold", size: 18)
        label.textColor =  UIColor(red: 0.561, green: 0.604, blue: 0.627, alpha: 1)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
        leftConstraint =   messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 5)
        rightConstraint =  messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -5)
        
        currentConstraint = messageContent.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 10)
        receiverConstraint = messageContent.topAnchor.constraint(equalTo: senderName.bottomAnchor, constant: 5)
        senderConstraint = senderName.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 10)
        
        addSubview(messageContainer)
        messageContainer.addSubview(messageContent)
        messageContainer.addSubview(time)
        messageContainer.addSubview(senderName)
        
        NSLayoutConstraint.activate([
            messageContent.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            messageContainer.widthAnchor.constraint(equalTo: messageContent.widthAnchor, constant: 80),
            messageContainer.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            //messageContent.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 5),
            messageContent.leftAnchor.constraint(equalTo: messageContainer.leftAnchor, constant: 10),
            time.topAnchor.constraint(equalTo: messageContent.bottomAnchor),
            //time.leftAnchor.constraint(equalTo: messageContent.rightAnchor),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor),
            time.rightAnchor.constraint(equalTo: messageContainer.rightAnchor),
            senderName.leftAnchor.constraint(equalTo: messageContainer.leftAnchor, constant: 10),
                  //senderName.widthAnchor.constraint(equalToConstant: 80),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureSenderData() {
        for user in usersList! {
          if messageItem?.sender == user.uid {
            senderName.text = user.username
          }
        }
      }
    
    func configure(){
//        backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        messageContent.text = messageItem?.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: messageItem!.time)
        if messageItem?.sender == DatabaseManager.shared.getUID(){
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = UIColor(red: 0.165, green: 0.627, blue: 0.573, alpha: 1)
            senderName.isHidden = true
            receiverConstraint.isActive = false
            senderConstraint.isActive = false
            currentConstraint.isActive = true
        }else{
            leftConstraint?.isActive =  true
            rightConstraint?.isActive = false
            messageContainer.backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
            senderName.isHidden = false
            currentConstraint.isActive = false
            receiverConstraint.isActive = true
            senderConstraint.isActive = true
        }
    }
    
    
}
