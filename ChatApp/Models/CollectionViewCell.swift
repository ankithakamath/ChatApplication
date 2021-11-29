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
    
    var imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Message"
        label.textColor = .green
        label.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.text = "12:00pm"
        label.textColor = .black
        label.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
//    var checkButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.setImage(UIImage(systemName: "circle"), for: .normal)
//
//        //button.isHidden = true
//        button.translatesAutoresizingMaskIntoConstraints =  false
//        button.addTarget(self, action: #selector(checkBoxAction), for: .touchUpInside)
//        return button
//    }()
    
//    @objc func checkBoxAction(){
//        isChecked = !isChecked
//        if isChecked {
//            checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//        }else {
//            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
//        }
//    }
//
//    func isEditingEnabled(){
//        if isEditing{
//            self.isHidden = false
//            checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//        }else{
//
//            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        //contentView.addSubview(checkButton)
        imageView.layer.cornerRadius = 35
        contentView.clipsToBounds = true
        configureCheckBox()
        
    }
    
    func configureCheckBox(){
        print(".....................")

        //configureCheckBox()
       
        
    }
   
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {


//        checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
//
//        checkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        checkButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//
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
}
