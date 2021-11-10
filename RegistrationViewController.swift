//
//  RegistrationViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    
    
    let photoButton: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.fill")
        imageView.layer.cornerRadius = 60
//        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
//        button.addTarget(self, action: #selector(handleProfilePic), for: .touchUpInside)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    let firstNameTextField: UITextField = {
        let tF = UITextField()
        tF.placeholder = "Enter First Name"
        tF.textColor = .black
        tF.backgroundColor = .red
        tF.font = UIFont.systemFont(ofSize: 20)
        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tF.translatesAutoresizingMaskIntoConstraints = false
        return tF
    }()
    
    let lastNameTextField: UITextField = {
        let tF = UITextField()
        tF.placeholder = "Enter Last Name"
        tF.textColor = .black
        tF.backgroundColor = .red
        tF.font = UIFont.systemFont(ofSize: 20)
        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tF.translatesAutoresizingMaskIntoConstraints = false
        return tF
    }()
    
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
        tF.isSecureTextEntry = true
        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tF.translatesAutoresizingMaskIntoConstraints = false
        return tF
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
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
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        
        view.addSubview(photoButton)
        
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//
        let stack = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, signUpButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: photoButton.bottomAnchor , constant: 40).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    @objc func handleLogin(){
        print("Login button tapped")
    }
    
    @objc func handleProfilePic(){
        
    }

}
