//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 17/11/21.
//

import UIKit
import FirebaseStorage

class ChatViewController:UITableViewController {
    
    var messages: [Message] = []
    let cellIdentifier = "chatCell"
    var otherUser: UserData!
    var currentUser: UserData!
    //var chatId: String?
    var chat:Chats!
    let uid = DatabaseManager.shared.getUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchChats()
        
        configure()
        configurekeyboard()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func configureTableView() {
        tableView.backgroundColor  = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
    }
    
    let textField1 = CustomTextField(placeholder: "Type Something")
    
    let sendButton:UIButton = {
        let sendButton = UIButton()
        sendButton.backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
        sendButton.tintColor = UIColor(red: 0, green: 0.69, blue: 0.612, alpha: 1)
        sendButton.setImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        sendButton.contentVerticalAlignment = .fill
        sendButton.contentHorizontalAlignment = .fill
        
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        sendButton.layer.cornerRadius = 25
        return sendButton
    }()
    
    let addimageButton:UIButton = {
        let addimageButton = UIButton()
        addimageButton.backgroundColor = .gray
        addimageButton.tintColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
        addimageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        //addimageButton.contentVerticalAlignment = .fill
        //addimageButton.contentHorizontalAlignment = .fit
        addimageButton.addTarget(self, action: #selector(sendImageChat), for: .touchUpInside)
        addimageButton.layer.cornerRadius = 25
        return addimageButton
    }()
    
    @objc func sendImageChat(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func sendChat(){
        
        if textField1.text != "" {
            let newMessage = Message(sender: currentUser.uid, content: textField1.text!, time: Date(), seen: false, imageChat: "")
            messages.append(newMessage)
            DatabaseManager.shared.addMessage(messages: messages, lastMessage: newMessage, id: chat.chatId!)
            textField1.text = ""
        }
    }
    func configurekeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -260
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func fetchChats() {
        messages = []
        DatabaseManager.shared.getUser(uid: uid!) { user in
            self.currentUser = user
        }
        
        DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: [0, self.messages.count - 1], at: .bottom, animated: true)
                
            }
        }
    }
    func uploadImagetoDb(image: UIImage, name: String, completion: @escaping(String) -> Void) {
        
        let storage = Storage.storage().reference()
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        storage.child(name).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            
            storage.child("Profile").child(name).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                print("Download URL: \(urlString)")
                completion(urlString)
            }
        }
    }
    
    
    
    func uploadPhoto(image: UIImage) {
        let path = "Chats/\(chat.chatId!)/\(UUID())"
        let newMessage = Message(sender: self.currentUser.uid, content: "", time: Date(), seen: false, imageChat: path)
        var messagesArray = self.messages
        messagesArray.append(newMessage)
        uploadImagetoDb(image: image, name: path) { url in
            
        }
        DatabaseManager.shared.addMessage(messages: messagesArray, lastMessage: newMessage, id: chat.chatId!)
        self.tableView.reloadData()
    }
    
    func configure() {
        
        var name: String
        if chat.isGroupChat! {
            name = chat.groupName!
        } else {
            if chat.users[0].uid == uid {
                name = chat.users[1].username
            } else {
                name = chat.users[0].username
            }
        }
        navigationItem.title = name
        
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        textField1.backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
        
        view.addSubview(textField1)
        view.addSubview(sendButton)
        view.addSubview(addimageButton)
        textField1.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addimageButton.translatesAutoresizingMaskIntoConstraints = false
        textField1.layer.cornerRadius = 20
        NSLayoutConstraint.activate([
            
            textField1.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 5),
            textField1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField1.heightAnchor.constraint(equalToConstant: 50),
            textField1.rightAnchor.constraint(equalTo: addimageButton.leftAnchor, constant: 0),
            textField1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -105),
            addimageButton.leftAnchor.constraint(equalTo: textField1.rightAnchor, constant: -10),
            addimageButton.widthAnchor.constraint(equalToConstant: 50),
            addimageButton.heightAnchor.constraint(equalToConstant: 50),
            addimageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.leftAnchor.constraint(equalTo: addimageButton.rightAnchor, constant: 0),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField1.rightAnchor.constraint(equalTo: addimageButton.leftAnchor, constant: 0)
        ])
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].imageChat == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell" , for: indexPath) as! MessageCell
            let messagesItem = messages[indexPath.row]
            cell.messageItem = messagesItem
            cell.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
            cell.usersList = chat.users
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
            cell.messageItem = messages[indexPath.row]
            cell.usersList = chat.users
            
            Storagemanager.shared.downloadImageWithPath(path: messages[indexPath.row].imageChat!, completion: { image in
                DispatchQueue.main.async {
                    cell.chatImage.image = image
                    
                }
            })
            
            cell.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadPhoto(image: imageSelected)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
