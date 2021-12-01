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
    
    var chats:[Chats] = []
    let cellIdentifier = "userCell"
    var users : [UserData] = []
    var hasFetched = false
    var currentUser: UserData?
    var searchUsers: [UserData] = []
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    private var inSearchMode: Bool {
        return !searchController.searchBar.text!.isEmpty
    }
    
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
        DatabaseManager.shared.getAllUsers() { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureSearchBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
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
        return inSearchMode ? searchUsers.count : users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conversationCell", for: indexPath) as! CollectionViewCell
        let user = inSearchMode ? searchUsers[indexPath.row] : users[indexPath.row]
        
        cell.nameLabel.text = user.email
        cell.messageLabel.text = user.username
        cell.timeLabel.isHidden = true
        //cell.selectButton.isHidden = true
        
        let uid = user.uid
        
        Storagemanager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectttttttttttttt")
        let selectedUser = users[indexPath.row]
        let users: [UserData] = [currentUser!, selectedUser]
        
        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
        let chatVC = ChatViewController()
        var vcArray = navigationController?.viewControllers
        vcArray?.removeLast()
        
        for chat in chats {
            var currentChat = chat
            let uid1 = chat.users[0].uid
            let uid2 = chat.users[1].uid
            
            if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                print("Already Chated")
                
                currentChat.otherUser =  uid1 == currentUser!.uid ? 1 : 0
                chatVC.chat = currentChat
                
                vcArray?.append(chatVC)
                navigationController?.setViewControllers(vcArray!, animated: true)
                
                return
            }
            
        }
        print("New Chat")
        DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        
        chatVC.chat = Chats(chatId: id, users: users, lastMessage: nil, messages: [], otherUser: 1)
        
        vcArray?.append(chatVC)
        navigationController?.setViewControllers(vcArray!, animated: true)
        //        navigationController?.popViewController(animated: false)
        //        navigationController?.pushViewController(chatVC, animated: true)
        
    }
}


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
        let searchText = searchController.searchBar.text!
        if inSearchMode {
            searchUsers.removeAll()
            
            for user in users {
                if user.username.lowercased().contains(searchText.lowercased()) || user.email.lowercased().contains(searchText.lowercased()) {
                    searchUsers.append(user)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
    }
}

