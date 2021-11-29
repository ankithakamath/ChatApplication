//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 17/11/21.
//

import UIKit

class ChatViewController:UITableViewController {
    
    var messages: [MessageModel] = []
    
    let cellIdentifier = "chatCell"
    var otherUser: User!
    var currentUser: User!
    var chatId: String?
    var chat:ChatModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchChats()
        view.backgroundColor = .lightGray
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func configureTableView() {
        
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
    }
    
    let textField1 = CustomTextField(placeholder: "Type...")
    let sendButton:UIButton = {
        let sendButton = UIButton()
        sendButton.backgroundColor = .red
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        
        //sendButton.layer.cornerRadius = 50
        //sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return sendButton
    }()
    
    
    let Button:UIButton = {
        let sendButton = UIButton()
        sendButton.backgroundColor = .red
        sendButton.setTitle(" Send ", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //sendButton.layer.cornerRadius = 50
        //sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return sendButton
    }()
    
    
    @objc func sendChat(){
        if textField1.text != "" {
            let newMessage = MessageModel(sender: currentUser.uid, message: textField1.text!, time: Date())
            messages.append(newMessage)
            chat?.lastMessage = newMessage
            DatabaseManager.shared.addMessage(chat: chat!, id: chatId!, messageContent: messages)
            textField1.text = ""
            DispatchQueue.main.async {
                self.tableView.reloadData()
             
            }
        }
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -260
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func fetchChats() {
        messages = []
        print("before guard..........")
        guard let chatId = chatId else {
            return
        }
        print("after guard............")
        DatabaseManager.shared.fetchMessages(chatId: chatId) { messages in
            
            print("........fetching chats............")
            self.messages = messages
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func configure() {
        if chat.otherUserIndex == 0 {
                  otherUser = chat.users[0]
                  currentUser = chat.users[1]
                } else {
                  otherUser = chat.users[1]
                  currentUser = chat.users[0]
                }
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
        Button.translatesAutoresizingMaskIntoConstraints = false
        // messages.append(newMessage
        view.addSubview(textField1)
        view.addSubview(sendButton)
        textField1.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            textField1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField1.heightAnchor.constraint(equalToConstant: 50),
            textField1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField1.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5)
        ])
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell" , for: indexPath) as! MessageCell
        
        let messageItem = messages[indexPath.row]
        cell.message = messageItem
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
