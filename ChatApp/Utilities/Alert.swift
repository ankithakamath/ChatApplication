//
//  Alert.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 21/11/21.
//

import UIKit

class AlertVC: UIViewController {
    
    let containerView = UIView()
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = BodyLabel(textAlignment: .center)
    let actionButton = Button(backgroundColor: .systemGray2, title: "Ok")
    var alertTitle:String?
    var message:String?
    var buttonTitle:String?
    
    init(title:String,message:String,buttonTitle:String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureBodyLabel()

    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
            
        ])
    }
    
    func configureTitleLabel() {
        //print(";;;;;;;;;;;;;;;;;;;;;;")
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = alertTitle ?? "something went wrong"
        
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])

        
    }
    
    func configureActionButton() {
        print(".........action.........")
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "ok", for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureBodyLabel() {
        //print("............\n")
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo:titleLabel.bottomAnchor,constant: 9),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor,constant: -12),
           
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20)
            
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: .none)
    }
    
}
