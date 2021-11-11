//
//  LoginViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    var emailTextField = CustomTextField(placeholder: "Enter Email")
    var passwordTextField = CustomTextField(placeholder: "Enter Password")
    
    lazy var emailContainer: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: passwordTextField)
    }()
    
//    lazy var emailContainerView: UIView = {
//        let Cview = UIView()
//        Cview.backgroundColor = .darkGray
//        Cview.clipsToBounds = true
//        Cview.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        Cview.translatesAutoresizingMaskIntoConstraints = false
//
//        let iv = UIImageView()
//        iv.image = UIImage(systemName: "person.fill")
//        Cview.addSubview(iv)
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        iv.leftAnchor.constraint(equalTo: Cview.leftAnchor, constant: 10).isActive = true
//        iv.centerYAnchor.constraint(equalTo: Cview.centerYAnchor).isActive = true
//
//        Cview.addSubview(emailTextField)
//        emailTextField.translatesAutoresizingMaskIntoConstraints = false
//        emailTextField.centerYAnchor.constraint(equalTo: Cview.centerYAnchor).isActive = true
//        emailTextField.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 10).isActive = true
//        emailTextField.rightAnchor.constraint(equalTo: Cview.rightAnchor ).isActive = true
//        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        return Cview
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI(){
        
        view.backgroundColor = .darkGray
        
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(loginButton)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 100).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    @objc func handleLogin(){
        print("Login button tapped")
    }
}
