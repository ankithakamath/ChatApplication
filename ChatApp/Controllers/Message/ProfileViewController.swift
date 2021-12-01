//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 15/11/21.
//

import UIKit
import FirebaseAuth
import SwiftUI

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var photoButton : UIImageView!
    let data = ["Log Out"]
    var otherUser: UserData!
    var currentUser: UserData?
    var imageView : UIImageView! = UIImageView()
    let username: UILabel! = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.tableHeaderView = createTableHeader()
        fetchUser()
    }
    
    func createTableHeader() -> UIView? {
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width
                                              , height: 300))
        headerView.backgroundColor = .white
        
        imageView = UIImageView(frame: CGRect(x: (headerView.frame.size.width - 250)/2, y: 25, width: 250, height: 250))
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.image = UIImage(systemName: "person.circle")
        imageView.layer.cornerRadius = 125
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        headerView.addSubview(imageView)
        headerView.addSubview(username)
        return headerView
        
    }
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func fetchUser(){
        let userid = DatabaseManager.shared.getUID()
        DatabaseManager.shared.getUser(uid: userid!) { [self] user in
            self.currentUser = user
            
            Storagemanager.shared.downloadImageWithPath(path: "Profile/\(currentUser!.uid)") { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            }
        }
    }
    
    //
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            let isLoggedOut = DatabaseManager.shared.onLogout()
            if isLoggedOut{
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
}
