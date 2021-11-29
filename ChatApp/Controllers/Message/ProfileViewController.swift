//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 15/11/21.
//

import UIKit
import FirebaseAuth
import SwiftUI

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var profileimage:UIImageView!
    let data = ["Log Out"]
    var path : String!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
       fetchUser()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.green
        fetchUser()
    }
    
    func createTableHeader() -> UIView? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
     
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width
                                              , height: 300))
        headerView.backgroundColor = .lightGray
        headerView.contentMode = .scaleAspectFill
        headerView.layer.borderColor = UIColor.gray.cgColor
        headerView.layer.borderWidth = 3
        headerView.layer.masksToBounds = true
        
        
        let imageview = UIImageView(frame: CGRect(x: (headerView.frame.size.width - 250)/2, y: 25, width: 250, height: 250))
        imageview.backgroundColor = .white
        imageview.layer.borderColor = UIColor.blue.cgColor
        //imageview.layer.borderWidth = 5
        imageview.layer.cornerRadius = imageview.frame.size.width/2
        headerView.addSubview(imageview)
        
//        Storagemanager.shared.downloadURL(for: path, completion: {[weak self] result in
//            switch result {
//            case .success(let url):
//                self?.downloadImage(imageView: imageview, url: url)
//            case .failure(let error):
//                print("failed to get download url\(error)")
//            }
//        })
        return headerView
        
    }
    
    func fetchUser(){
          let uid = Auth.auth().currentUser?.uid
        print( "Profile/\(uid))")
        Storagemanager.shared.downloadImageWithPath(path: "Profile/\(uid)") { [self] image in
              print("..........................")
            profileimage.image = image
          }
    }
    
//
     
    
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
        //        cell.textLabel?.font = .systemFont(ofSize: 20)
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
