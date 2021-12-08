//
//  CollectionViewCell.swift
//  Customcell
//
//  Created by Ankitha Kamath on 09/11/21.
//
import UIKit
import SwiftUI

class CollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "conversationCell"
    
    
    var isChecked: Bool = false
    var isEditing: Bool = false
    var chat: Chats? {
        didSet {
            configureChat()
        }
    }
    
    var lastMessageItem: Message? {
        didSet {
            checkLastMessage()
        }
    }
    
    var imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 35
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderColor = UIColor.white.cgColor
        iv.image = UIImage(systemName: "person.fill")
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.827, green: 0.855, blue: 0.878, alpha: 1)
        label.font = UIFont(name: "PTSans-Regular", size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
       
        label.textColor = UIColor(red: 0.561, green: 0.604, blue: 0.627, alpha: 1)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PTSans-Regular", size: 18)
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        
       
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.561, green: 0.604, blue: 0.627, alpha: 1)

        label.font = UIFont(name: "PTSans-Regular", size: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureChat()
        imageView.layer.cornerRadius = 35
        contentView.clipsToBounds = true
        
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func checkLastMessage() {
        messageLabel.text = lastMessageItem?.content
        //let sentImage = UIImageView()
    }
    
    func configure(){
        backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
       layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.094, green: 0.145, blue: 0.176, alpha: 1).cgColor
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        messageLabel.numberOfLines = 1
        messageLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        messageLabel.textAlignment = .left
        
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
    }
    
    func configureChat() {
        guard let chat = chat else { return }
        
        lastMessageItem = chat.lastMessage
        var path: String
        if chat.isGroupChat!{
            nameLabel.text = chat.groupName
            path = chat.groupIconPath!
        }else{
            let otherUser = chat.users[chat.otherUser!]
            nameLabel.text = otherUser.username
            path = "Profile/\(otherUser.uid)"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        if chat.lastMessage == nil {
            timeLabel.text = ""
            
        } else {
            timeLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        Storagemanager.shared.downloadImageWithPath(path: path) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
        }
        
    }
    
}
