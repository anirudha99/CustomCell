//
//  LoginViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    
    let emailTextField: UITextField = {
        let tF = UITextField()
        tF.placeholder = "Enter Email"
        tF.textColor = .black
        tF.backgroundColor = .red
        tF.font = UIFont.systemFont(ofSize: 20)
        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tF.translatesAutoresizingMaskIntoConstraints = false
        return tF
    }()
    
    let passwordTextField: UITextField = {
        let tF = UITextField()
        tF.placeholder = "Enter Password"
        tF.textColor = .black
        tF.backgroundColor = .red
        tF.font = UIFont.systemFont(ofSize: 20)
        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tF.translatesAutoresizingMaskIntoConstraints = false
        return tF
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    func configureUI(){
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 100).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    @objc func handleLogin(){
        print("Login button tapped")
    }
}
