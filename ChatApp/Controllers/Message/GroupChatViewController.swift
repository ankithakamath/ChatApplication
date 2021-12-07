//
//  GroupChatViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 06/12/21.
//

import UIKit
import SwiftUI

class GroupChatViewController: UIViewController {
    
    
    var users: [UserData] = []
    var collectionView: UICollectionView!
    var selectedUsers: [IndexPath] = []
    var currentUser: UserData!
    let uid = DatabaseManager.shared.getUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hidesBottomBarWhenPushed = true
        configureCollectionView()
        configureUI()
        fetchAllUser()
    }
    
    
    let groupPhotoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Group Photo"
        return label
    }()
    
    let groupNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Group Name"
        return label
    }()
    
    let groupPhoto : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle")
        //image.tintColor = .white
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 100
        image.clipsToBounds = true
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let groupNameTextField = CustomTextField(placeholder: "Enter Group Name")
    
    lazy var groupNameContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "person.3.fill")!, textField: groupNameTextField)
    }()
    
    
    let selectUsersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "select Users"
        return label
    }()
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    //
    @objc func handleCreate() {
        let validateResult = validateGroupChat(groupPhoto: groupPhoto.image!, groupName: groupNameTextField.text!, selectedUsersCount: selectedUsers.count)
        if validateResult == "" {
            let chatVC = ChatViewController()
            var vcArray = navigationController?.viewControllers
            vcArray?.removeLast()
            
            
            let chatID = "\(groupNameTextField.text!)_\(UUID())"
            let groupPath = "Profile/\(chatID)"
            var usersList: [UserData] = []
            usersList.append(currentUser)
            
            for indexPath in selectedUsers {
                let user = users[indexPath.row]
                usersList.append(user)
            }
            Storagemanager.ImageUploader.uploadImage(image: groupPhoto.image!, path: groupPath ){ url in
                
            }
            DatabaseManager.shared.addChat(users: usersList, id: chatID, isGroupChat: true, groupName: groupNameTextField.text, groupIconPath: groupPath)
            
            chatVC.chat = Chats(chatId: chatID, users: usersList, lastMessage: nil, messages: [], isGroupChat: true, groupName: groupNameTextField.text, groupIconPath: groupPath)
            
            vcArray?.append(chatVC)
            navigationController?.setViewControllers(vcArray!, animated: true)
            
        } else {
            
            showAlert(title: "Failed", messageContent: validateResult)
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == groupNameTextField {
            groupNameContainer.layer.borderColor = groupNameTextField.text!.count > 2 ? UIColor.blue.cgColor: UIColor.red.cgColor
        }
    }
    
    func configureUI() {
        groupNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        let createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handleCreate))
        navigationItem.rightBarButtonItems = [createButton]
        
        view.backgroundColor = .white
        navigationItem.title = "Create Group Chat"
        navigationItem.backButtonTitle = ""
        
        groupPhoto.layer.borderWidth = 1
        groupPhoto.layer.borderColor = UIColor.red.cgColor
        groupPhoto.clipsToBounds = true
        groupPhoto.isUserInteractionEnabled = true
        groupPhoto.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        groupPhoto.addGestureRecognizer(tapGesture)
        
        view.addSubview(groupPhotoLabel)
        view.addSubview(groupPhoto)
        view.addSubview(groupNameLabel)
        view.addSubview(groupNameContainer)
        view.addSubview(selectUsersLabel)
        
        groupPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        groupPhoto.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        groupNameContainer.translatesAutoresizingMaskIntoConstraints = false
        selectUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        NSLayoutConstraint.activate([
            
            groupPhotoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupPhotoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupPhoto.topAnchor.constraint(equalTo: groupPhotoLabel.bottomAnchor, constant: 5),
            groupPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupNameLabel.topAnchor.constraint(equalTo: groupPhoto.bottomAnchor, constant: 20),
            groupNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupNameContainer.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 5),
            groupNameContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            groupNameContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            selectUsersLabel.topAnchor.constraint(equalTo: groupNameContainer.bottomAnchor, constant: 20),
            selectUsersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: selectUsersLabel.bottomAnchor, constant: 5),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    
    func validateGroupChat(groupPhoto: UIImage, groupName: String, selectedUsersCount: Int) -> String {
        if groupPhoto == UIImage(systemName: "person.3") {
            return "invalid group photo"
        }
        if groupName.count < 3 {
            return "Invalid Group Name"
        }
        if selectedUsersCount < 1 {
            return "minimum error"
        }
        return ""
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "conversationCell")
    }
    
    func fetchAllUser() {
        DatabaseManager.shared.getUser(uid: uid!) { user in
            self.currentUser = user
        }
        DatabaseManager.shared.getAllUsers() { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension GroupChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conversationCell", for: indexPath) as! CollectionViewCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.email
        cell.messageLabel.text = user.username
        cell.timeLabel.isHidden = true
        //cell.selectButton.isHidden = true
        if selectedUsers.contains(indexPath) {
            cell.backgroundColor = .systemMint
        } else {
            cell.backgroundColor = .white
        }
        
        
        Storagemanager.shared.downloadImageWithPath(path: "Profile/\(user.uid)") { image in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        
        if selectedUsers.contains(indexPath) {
            selectedUsers.remove(at: selectedUsers.firstIndex(of: indexPath)!)
            selectedCell.backgroundColor = .white
        } else {
            selectedUsers.append(indexPath)
            selectedCell.backgroundColor = .blue
        }
    }
}

extension GroupChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GroupChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else {
            return
        }
        self.groupPhoto.image = selectedImage
    }
    
}

