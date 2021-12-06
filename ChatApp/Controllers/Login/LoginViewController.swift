//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 15/11/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        configureUI()
        configureNotificationObserver()
         createDismissKeyboardTapGesture()
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    var emailTextField = CustomTextField(placeholder: "Enter Valid Email")
    var passwordTextField = CustomTextField(placeholder: "Enter Valid Password")
    
    lazy var emailContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "mail.fill")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainer: InputContainer = {
        return InputContainer(image: UIImage(systemName: "lock.fill")!, textField: passwordTextField)
    }()
    let scrollview = UIScrollView()
    let photoButton: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        
        imageView.image = UIImage(systemName: "message.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .red
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let resetButton : UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password ?", for: .normal)
        button.tintColor = .red
        button.backgroundColor = .systemMint
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let SignupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Signup", for: .normal)
        button.tintColor = .red
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .systemMint
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Dont have an account?"
        return label
    }()
    
    
    @objc func handleForgotPassword() {
           
           let resetVC = ResetViewController()
           resetVC.modalPresentationStyle = .fullScreen
           navigationController?.pushViewController(resetVC, animated: true)
       }
    
    @objc func loginButtonTapped(){
        let error = validateFields()
        
        if error != nil {
            showAlert(title: "Error", messageContent:error!)
        }else{
            
            FirebaseAuth.Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] authResult, error in
                guard self != nil else{
                    return
                }
                guard let result = authResult,error == nil else{
                    print("failed to login")
                    return
                }
                let user = result.user
                print("\n logged in ",user)
                UserDefaults.standard.set(self!.emailTextField.text!,forKey: "email")
                self!.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func validateFields() -> String? {
        
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
    
    func createDismissKeyboardTapGesture(){
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        }
    
    func alertUser(){
        let alert = UIAlertController(title: "OOPS", message: "Please fill all fields to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert,animated: true)
    }
    
    @objc func handleSignup(){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func configureUI() {
       
        let stack = UIStackView(arrangedSubviews: [photoButton,emailContainer, passwordContainer,loginButton,resetButton,descriptionLabel,SignupButton])
        stack.spacing = 10
        view.addSubview(scrollview)
        scrollview.addSubview(stack)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 5).isActive = true
        stack.leftAnchor.constraint(equalTo: scrollview.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: scrollview.rightAnchor, constant: -20).isActive = true
        stack.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true
        scrollview.contentSize = CGSize(width: view.frame.width, height: 1000)
        passwordTextField.isSecureTextEntry = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
    
   
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[0-9])(?=.*[A-Z])(?=.*[@#$%^&+=]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email : String) -> Bool {
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@","^[a-zA-z0-9]+?(.)[a-zA-Z0-9+_-]*@[a-zA-Z]+\\.[a-zA-z]{2,4}?(.)[A-za-z]*$")
        return emailTest.evaluate(with: email)
    }
    
    func configureNotificationObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollingTheView), name: UIDevice.orientationDidChangeNotification, object: nil)
      }
    
    @objc func scrollingTheView() {
    
            scrollview.contentSize = CGSize(width: view.frame.width, height: 1000)
        }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            loginButtonTapped()
        }
        return true
    }
}
