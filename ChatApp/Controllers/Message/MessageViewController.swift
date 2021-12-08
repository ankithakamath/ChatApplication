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
        title = "chats"
        validateAuth()
        
    }
    
    @objc func didTapEdit() {
    }
    
    
    func configureNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.118, green: 0.635, blue: 0.58, alpha: 1)]
        appearance.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        navigationItem.rightBarButtonItem?.tintColor =  UIColor(red: 0.047, green: 0.663, blue: 0.588, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "person.3"),style: .plain, target: self, action: #selector(didTapGroupChat))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.047, green: 0.663, blue: 0.588, alpha: 1)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0.047, green: 0.663, blue: 0.588, alpha: 1)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    @objc func didTapGroupChat(){
        let groupVC = GroupChatViewController()
        navigationController?.pushViewController(groupVC, animated: true)
        
    }
    @objc func didTapSearch(){
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
        
        DatabaseManager.shared.getUser(uid:  DatabaseManager.shared.getUID()!) { currentUser in
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
        collectionView.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "conversationCell")
    }
    
}

extension MessageViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conversationCell" , for: indexPath) as! CollectionViewCell
        let chat = chats[indexPath.row]
        cell.backgroundColor =  UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
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
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

