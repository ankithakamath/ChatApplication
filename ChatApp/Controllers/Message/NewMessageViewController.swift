//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 15/11/21.
//

import UIKit
import SwiftUI
import FirebaseAuth

class NewMessageViewController: UIViewController {
    
    var conversations:[ChatModel] = []
    let cellIdentifier = "userCell"
    private var users = [User]()
    private var results = [User]()
    var searching = false
    private var hasFetched = false
    var currentUser: User?
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    
    
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "search for contacts"
//
//        return searchBar
//    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Matching Results found"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        
        view.backgroundColor = .lightGray
        
       // searchBar.delegate = self
        //searchBar.becomeFirstResponder()
        configureSearchBar()
        configureCollectionView()
        fetchAllUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noResultLabel.frame = CGRect(x: view.frame.size.width/4, y: (view.frame.size.height - 200)/2, width: view.frame.size.width/2, height: 200)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "conversationCell")
    }
    
    func fetchAllUser() {
        DatabaseManager.shared.getAllUsers(uid: uid) { users in
            self.users = users
            self.results = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureSearchBar(){
//        navigationController?.navigationBar.topItem?.titleView = searchBar
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
//        searchBar.becomeFirstResponder()
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        navigationItem.searchController?.automaticallyShowsCancelButton = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    
    @objc private func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewMessageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = searching ? results.count : users.count
            return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conversationCell", for: indexPath) as! CollectionViewCell
        
        let user = searching ? results[indexPath.row] : users[indexPath.row]
             //cell.text = user.email
           cell.messageLabel.text = user.username
           cell.timeLabel.isHidden = true
          
           // cell.selectButton.isHidden = true
           let uid = user.uid
           Storagemanager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
             cell.imageView.image = image
           }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectttttttttttttt")
        let selectedUser = searching ? results[indexPath.row] : users[indexPath.row]
        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
                let chatVC = ChatViewController()
            for chat in conversations {
               var currentChat = chat
               let uid1 = chat.users[0].uid
               let uid2 = chat.users[1].uid
               if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                currentChat.otherUserIndex = uid1 == currentUser!.uid ? 1 : 0
                chatVC.chat = currentChat
                chatVC.chatId = id
                 chatVC.title = selectedUser.username
                navigationController?.pushViewController(chatVC, animated: true)
                return
               }
              }
            DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
            present(chatVC, animated: true, completion: nil)
              }
          }
//        let selectedUser = results[indexPath.row]
//        let users: [User] = [currentUser!, selectedUser]
//        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
//        let chatVC = ChatViewController()
//        for chat in conversations {
//                      var currentChat = chat
//                      let uid1 = chat.users[0].uid
//                      let uid2 = chat.users[1].uid
//                      if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
//                        print("Already Chated")
//                        currentChat.otherUserIndex = uid1 == currentUser!.uid ? 1 : 0
//                        chatVC.chat = currentChat
//                          chatVC.title = selectedUser.username
//                        navigationController?.pushViewController(chatVC, animated: true)
//                        return
//                      }
//                    }
//        DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id )
//        chatVC.chat = ChatModel(users: users, lastMessage: nil, messagesArray: [], otherUserIndex: 1, chatId: id)
//        self.present(chatVC, animated: true, completion: nil)
  
    



extension NewMessageViewController: UICollectionViewDelegateFlowLayout {
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

extension NewMessageViewController:UISearchResultsUpdating,UISearchBarDelegate{
  func updateSearchResults(for searchController: UISearchController) {
    let count = searchController.searchBar.text?.count
    let searchText = searchController.searchBar.text!
    if !searchText.isEmpty {
      searching = true
      results.removeAll()
      results = users.filter({$0.username.prefix(count!).lowercased() == searchText.lowercased()})
        noResultLabel.isHidden = false
    }
    else{
      searching = false
      results = users
        
    }
    collectionView.reloadData()
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searching = false
    results = users
    collectionView.reloadData()
  }


//    func filterUsers(term:String) {
//        guard hasFetched else {
//            return
//        }
//        print(self.users)
//        self.results = self.users.filter({$0.username.lowercased() == term.lowercased()
//
//        })
//        print(results)
//        updateUI()
//    }
//
//    func updateUI(){
//        if results.isEmpty {
//            self.collectionView.isHidden = true
//            self.noResultLabel.isHidden = false
//        }else{
//            self.collectionView.isHidden = false
//            self.noResultLabel.isHidden = true
//        }
//        self.collectionView.reloadData()
//    }
}

