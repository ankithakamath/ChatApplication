//
//  ViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 15/11/21.
//

import UIKit
import FirebaseAuth
import SwiftUI


class MessageViewController: UIViewController {
    
    var currentUser:User?
    var tapped :Bool = false
    var conversations: [ChatModel] = []
    var collectionView: UICollectionView!
    
    private let noMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Messages"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    //    private let tableView: UITableView = {
    //        let table = UITableView()
    //        table.isHidden = true
    //        table.backgroundColor = .lightGray
    //        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    //        return table
    //
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.backgroundColor = .lightGray
        title = "chats"
        configureNavBar()
       
    }
    
    @objc func didTapEdit() {
        tapped = !tapped
        collectionView.reloadData()
    }
    
    func configureNavBar(){
        navigationController?.navigationBar.barTintColor = UIColor.green
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        // view.addSubview(tableView)
        view.addSubview(noMessageLabel)
        //setupTableView()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    
    @objc func didTapCompose(){
        let vc = NewMessageViewController()
        let navVC  = UINavigationController(rootViewController: vc)
        vc.conversations = conversations
        vc.currentUser = currentUser
        present(navVC,animated: true)
    }
    
    //    private func setupTableView(){
    //        tableView.delegate = self
    //        tableView.dataSource = self
    //    }
    
    func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: false)
            }
        }else{
            //configureNavigationBar()
            configureCollectionView()
            fetchAllUser()
            
        }
    }
    
    func fetchAllUser() {
        let uid = Auth.auth().currentUser?.uid
        
        DatabaseManager.shared.getUser(uid:uid!) { currentUser in
            self.currentUser = currentUser
        }
        
        DatabaseManager.shared.fetchChats(uid: uid!) { conversation in
            self.conversations = conversation
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "conversationCell")
    }
    
}
extension MessageViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conversationCell" , for: indexPath) as! CollectionViewCell
        let chat = conversations[indexPath.row]
        let otherUser = chat.users[chat.otherUserIndex!]
        cell.nameLabel.text = otherUser.username
        cell.messageLabel.text = chat.lastMessage?.message
        cell.backgroundColor = .white
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            cell.timeLabel.isHidden = true
        } else {
            cell.timeLabel.isHidden = false
            cell.timeLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        Storagemanager.shared.downloadImageWithPath(path: "Profile/\(otherUser.uid)") { image in
            cell.imageView.image = image
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectttttttttttttt")
        let user = conversations[indexPath.row]
        let Cvc = ChatViewController()
        Cvc.currentUser = currentUser
        Cvc.chat = user
        Cvc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(Cvc, animated: true)
    }
    
    
    
}


extension MessageViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

//extension MessageViewController: UITableViewDelegate,UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
//        cell.textLabel?.text = "Hello there"
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let Cvc = ChatViewController()
//        Cvc.title = "jenny smith"
//        Cvc.navigationItem.largeTitleDisplayMode = .never
//        self.navigationController?.pushViewController(Cvc, animated: true)
//        print ("-------------")
//    }
//}
