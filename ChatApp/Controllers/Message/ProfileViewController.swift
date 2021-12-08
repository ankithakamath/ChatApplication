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
    var resetButton : UIButton! = UIButton()
    var nameLabel: UILabel! = UILabel()
    let username: UILabel! = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        fetchUser()
        configurenavbar()
        hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.tableHeaderView = createTableHeader()
        fetchUser()
    }
    
    func configurenavbar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.118, green: 0.635, blue: 0.58, alpha: 1)]
        appearance.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func createTableHeader() -> UIView? {
        tableView.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 500))
        headerView.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        imageView = UIImageView(frame: CGRect(x: (headerView.frame.size.width - 250)/2, y: 25, width: 250, height: 250))
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.image = UIImage(systemName: "person.circle")
        imageView.layer.cornerRadius = 125
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        nameLabel = UILabel(frame: CGRect(x: (headerView.frame.size.width - 250)/2, y: 300, width: 250, height: 40))
        nameLabel.layer.borderColor = UIColor.white.cgColor
        nameLabel.layer.borderWidth = 1
        //nameLabel.text = "aaaa"
        nameLabel.textColor = UIColor(red: 0.773, green: 0.808, blue: 0.827, alpha: 1)
        
        nameLabel.font = UIFont(name: "PTSans-Regular", size: 17)
        
        nameLabel.textAlignment = .center
        // nameLabel.text = currentUser?.username
        
        resetButton = UIButton(frame: CGRect(x: (headerView.frame.size.width - 250)/2, y: 350, width: 250, height: 50))
        resetButton.layer.borderColor = UIColor.systemMint.cgColor
        resetButton.layer.cornerRadius = 20
        resetButton.backgroundColor = .systemMint
        resetButton.setTitle("Reset Password", for: .normal)
        resetButton.titleLabel?.textColor = .blue
        resetButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        headerView.addSubview(imageView)
        headerView.addSubview(resetButton)
        headerView.addSubview(nameLabel)
        
        return headerView
        
    }
    
    @objc func handleReset() {
        
        DatabaseManager.shared.resetPassword(email: currentUser!.email) { result in
            if result == "Sent" {
                self.showAlert(title: "Password Reset Email Sent", messageContent: "A Password Reset link has been sent to your Email")
            } else {
                self.showAlert(title: "Failed", messageContent: "Error while reseting the Password. Try Again Later")
            }
        }
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
            nameLabel.text = currentUser?.username
            Storagemanager.shared.downloadImageWithPath(path: "Profile/\(currentUser!.uid)") { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            }
        }
    }
    
    //
    //    func downloadImage(imageView: UIImageView, url: URL) {
    //        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
    //            guard let data = data, error == nil else {
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                let image = UIImage(data: data)
    //                imageView.image = image
    //            }
    //        }).resume()
    //    }
    
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
        cell.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            let isLoggedOut = DatabaseManager.shared.onLogout()
            if isLoggedOut{
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: false)
                // dismiss(animated: true)
            }
        }
    }
}
