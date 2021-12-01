//
//  CollectionViewCell.swift
//  Customcell
//
//  Created by Ankitha Kamath on 09/11/21.
//

import UIKit

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
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 35
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderColor = UIColor.white.cgColor
        iv.image = UIImage(systemName: "person.fill")
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Name"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Message"
        label.textColor = .black
        label.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureChat()
        imageView.layer.cornerRadius = 35
        contentView.clipsToBounds = true
        configureCheckBox()
        
    }
    
    func configureCheckBox(){
        print(".....................")

    }
   
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func checkLastMessage() {
            messageLabel.text = lastMessageItem?.content
            //let sentImage = UIImageView()

        }
    
    func configure(){
        backgroundColor = .systemBackground
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
            let otherUser = chat.users[chat.otherUser!]
            nameLabel.text = otherUser.username
            lastMessageItem = chat.lastMessage
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:a"
            if chat.lastMessage == nil {
                timeLabel.text = ""
             
            } else {
                timeLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
            }
          Storagemanager.shared.downloadImageWithPath(path: "Profile/\(otherUser.uid)") { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            }
            
        }
 
}
