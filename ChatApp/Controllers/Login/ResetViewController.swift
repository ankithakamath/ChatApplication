//
//  ResetViewController.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 06/12/21.
//

import UIKit
import FirebaseAuth

class ResetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        configure()
        configureNotificationObserver()
        createDismissKeyboardTapGesture()
        // Do any additional setup after loading the view.
    }
    let label : UILabel = {
            
            let label = UILabel()
            
            label.text = "Forgot password?"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 40.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            return label
        }()
    
    let resetButton : UIButton = {
        let button = UIButton()
        button.setTitle("Reset Password", for: .normal)
        button.tintColor = .red
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
        var emailTextField = CustomTextField(placeholder: "enter valid registered email here")
        let scrollView = UIScrollView()
        
        lazy var emailContainerView : InputContainer = {
            emailTextField.keyboardType = .emailAddress
            emailTextField.autocorrectionType = .no
            emailTextField.autocapitalizationType = .none
            return InputContainer(image: UIImage(systemName: "envelope")!, textField: emailTextField)

    }()
            
        func configure () {
            
            resetButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
//            backToLoginButton.addTarget(self, action: #selector(didTapBackToLogin), for: .touchUpInside)
            
            let stack = UIStackView(arrangedSubviews: [label, emailContainerView,resetButton])
            stack.translatesAutoresizingMaskIntoConstraints = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 30
            stack.axis = .vertical

            view.addSubview(scrollView)
            scrollView.addSubview(stack)
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 150).isActive = true
            stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            stack .widthAnchor.constraint(equalToConstant: 350).isActive = true
            scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
        }
        
        
        @objc func handleForgotPassword() {
            guard let email = emailTextField.text else { return }
            if LoginViewController.isEmailValid(email){
                    DatabaseManager.shared.resetPassword(email: email) { result in
                        if result == "Sent" {
                            self.showAlert(title: "Password Reset Email Sent", messageContent: "A Password Reset link has been sent to your Email")
                        } else {
                            self.showAlert(title: "Failed", messageContent: "Error while reseting the Password. Try Again Later")
                        }
                    }
                } else {
                    showAlert(title: "Invalid email", messageContent: "Please Enter a valid Registered Email")
                }
            

        }
        
        func configureNotificationObserver(){
            
            NotificationCenter.default.addObserver(self, selector: #selector(scrollingTheView), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    
    func createDismissKeyboardTapGesture(){
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        }
    
        
        @objc func didTapBackToLogin() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc func scrollingTheView() {
            
            scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
        }
        
    }


