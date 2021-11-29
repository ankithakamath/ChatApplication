//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 15/11/21.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureUI()
    }
    
    var firstNameTextField = CustomTextField(placeholder: "Enter First Name")
    var lastNameTextField = CustomTextField(placeholder: "Enter last Name")
    var emailTextField = CustomTextField(placeholder: "Enter Valid Email")
    var passwordTextField = CustomTextField(placeholder: "Enter Valid Password")
    
    let photoButton: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        //        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var firstNameContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "person.fill")!, textField: firstNameTextField)
        
    }()
    
    lazy var lastNameContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "person.fill")!, textField: lastNameTextField)
        
    }()
    
    lazy var usernameContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "mail.fill")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "lock.fill")!, textField: passwordTextField)
        
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .red
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector( SignInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func SignInButtonTapped(){
        let error = validateFields()
        if error != nil {
            showAlert(title: "ERROR", messageContent: error!)
            return
        }else{
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let  profilePic = photoButton.image
            
            DatabaseManager.shared.userAlreadyExists(email: email) { exists in
                guard !exists else {
                    print(exists)
                    self.showAlert(title: "ERROR", messageContent: "Email already exists")
                    return
                }
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard authResult != nil, error == nil else {
                    self?.showAlert(title: "ERROR", messageContent: "erroe in creating user")
                    return
                }
                let uid = authResult?.user.uid
                
                Storagemanager.ImageUploader.uploadImage(image: profilePic!, uid: uid!) { url in
                    let newUser = User(username: firstName + lastName, email: email, profileURL: url, uid: uid!)
                    DatabaseManager.shared.addUser(user: newUser)
                    // self?.delegate?.userAuthenticated()
                    self?.dismiss(animated: true)
                }
                self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in all details"
        }
        let cleanemail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if LoginViewController.isEmailValid(cleanemail) == false {
            return "please enter a valid email "
        }
        let cleanpassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if LoginViewController.isPasswordValid(cleanpassword) == false {
            return "please enter a valid password "
        }
        return nil
    }
    
    
    
    func alertUser(message: String = "Please fill all fields to Create a new account"){
        let alert = UIAlertController(title: "OOPS", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert,animated: true)
    }
    
    @objc func didTapChangeProfileImage(){
        presentPhotoActionSheet()
    }
    
    func configureUI() {
        let stack = UIStackView(arrangedSubviews: [ photoButton,firstNameContainer,lastNameContainer,usernameContainer,passwordContainer,signupButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        
        
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        photoButton.layer.cornerRadius = photoButton.frame.size.width/2
        //photoButton.layer.cornerRadius = 1
        //passwordTextField.isSecureTextEntry = true
        photoButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfileImage))
        photoButton.addGestureRecognizer(gesture)
        
        
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            //loginButtonTapped()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentAlbums()
        }))
        present(actionSheet,animated: true)
        
    }
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentAlbums(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else {
            return
        }
        self.photoButton.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

