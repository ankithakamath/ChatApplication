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
        view.backgroundColor = .systemMint
        configureUI()
        configureNotificationObserver()
        createDismissKeyboardTapGesture()
    }
    
    var firstNameTextField = CustomTextField(placeholder: "Enter First Name")
    var lastNameTextField = CustomTextField(placeholder: "Enter last Name")
    var emailTextField = CustomTextField(placeholder: "Enter Valid Email")
    var passwordTextField = CustomTextField(placeholder: "Enter Valid Password")
    let scrollview = UIScrollView()
    let photoButton: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
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
                    self?.showAlert(title: "ERROR", messageContent: "error in creating user")
                    return
                }
                let uid = authResult?.user.uid
                let path = "Profile/\(uid!)"
                Storagemanager.ImageUploader.uploadImage(image: profilePic! , path: path) { url in
                 
                    self?.dismiss(animated: true)
                }
                let newUser = UserData(username: firstName, email: email, profileURL: "Profile/\(uid!)", uid: uid!)
                DatabaseManager.shared.addUser(user: newUser)
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
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
        
        let stack = UIStackView(arrangedSubviews: [firstNameContainer,lastNameContainer,usernameContainer,passwordContainer,signupButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(scrollview)
        scrollview.addSubview(photoButton)
        scrollview.addSubview(stack)
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoButton.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 0).isActive = true
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 20).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
      
        photoButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfileImage))
        photoButton.addGestureRecognizer(gesture)
        
        
    }
    
    
    func configureNotificationObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollingTheView), name: UIDevice.orientationDidChangeNotification, object: nil)
      }
    
    @objc func scrollingTheView() {
    
            scrollview.contentSize = CGSize(width: view.frame.width, height: 1000)
        }
    
    func createDismissKeyboardTapGesture(){
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
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

