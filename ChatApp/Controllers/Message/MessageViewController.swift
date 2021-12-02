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
    
    var chats: [Chats] = []
    var currentUser: UserData?
    var collectionView: UICollectionView!
    var uid : String!
    var lastMessageItem: Message?
    
    
    
    private let noMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Messages"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.gray
        //view.backgroundColor = .lightGray
        title = "chats"
        validateAuth()
    }
    
    @objc func didTapEdit() {
    }
    
    
    func configureNavBar(){
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .systemMint
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        view.addSubview(noMessageLabel)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    
    @objc func didTapCompose(){
        let vc = NewMessageViewController()
        vc.currentUser = currentUser
        vc.chats = chats
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: false)
            }
        }else{
            configureNavBar()
            fetchUserData()
            configureCollectionView()
            
            
            
        }
    }
    
    func fetchUserData() {
        chats = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        DatabaseManager.shared.getUser(uid: DatabaseManager.shared.getUID()!) { currentUser in
            self.currentUser = currentUser
        }
        DatabaseManager.shared.fetchChats(uid: DatabaseManager.shared.getUID()!) { chats in
            self.chats = chats
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
       // collectionView.backgroundColor = .white
        //collectionView.layer.borderColor = UIColor.lightGray.cgColor
        //collectionView.layer.borderWidth = 2
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "conversationCell")
    }
    
}

extension MessageViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conversationCell" , for: indexPath) as! CollectionViewCell
        let chat = chats[indexPath.row]
        cell.messageLabel.text = chat.lastMessage?.content
        cell.chat = chat
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectttttttttttttt")
        let Cvc = ChatViewController()
        Cvc.chat = chats[indexPath.row]
        Cvc.hidesBottomBarWhenPushed = true
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

