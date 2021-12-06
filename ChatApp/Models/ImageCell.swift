//
//  ImageCell.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 06/12/21.
//

import UIKit

class ImageCell: UITableViewCell {
    
    static let reuseIdentifier = "imageCell"
    var leftConstraint : NSLayoutConstraint?
    var rightConstraint :NSLayoutConstraint?
    var messageItem: Message?{
        didSet{
            configureChatImage()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
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
        chatimage.contentMode = .scaleAspectFit
        chatimage.translatesAutoresizingMaskIntoConstraints = false
        return chatimage
    }()
    
    func configureChatImage(){
        Storagemanager.shared.downloadImageWithPath(path: messageItem!.imageChat!, completion: { image in
            DispatchQueue.main.async {
                self.chatImage.image = image
            }
        })
        leftConstraint =   messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 5)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -5)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: messageItem!.time)
        addSubview(messageContainer)
        messageContainer.addSubview(chatImage)
        messageContainer.addSubview(time)
        if messageItem?.sender == DatabaseManager.shared.getUID(){
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = .systemMint
        }else{
            leftConstraint?.isActive =  true
            rightConstraint?.isActive = false
            messageContainer.backgroundColor = .systemGray2
        }
        NSLayoutConstraint.activate([
            
            messageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageContainer.widthAnchor.constraint(equalTo: chatImage.widthAnchor, constant: 10),
            messageContainer.heightAnchor.constraint(equalTo: chatImage.heightAnchor, constant: 40 ),
            chatImage.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 5),
            chatImage.centerXAnchor.constraint(equalTo: messageContainer.centerXAnchor),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor),
            time.rightAnchor.constraint(equalTo: messageContainer.rightAnchor)
            
        ])
        
    }
    
    
}
