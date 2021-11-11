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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemRed
        return imageView
    }()
    
    var firstNameTextField = CustomTextField(placeholder: "Enter First Name")
    var lastNameTextField = CustomTextField(placeholder: "Enter Last Name")
    var emailTextField = CustomTextField(placeholder: "Enter Email")
    var passwordTextField = CustomTextField(placeholder: "Enter Password")
    
    lazy var firstNameContainer: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: firstNameTextField)
    }()
    
    lazy var lastNameContainer: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: lastNameTextField)
    }()
    
    lazy var emailContainer: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: passwordTextField)
    }()
    
//
//  
//    
//    let passwordTextField: UITextField = {
//        let tF = UITextField()
//        tF.placeholder = "Enter Password"
//        tF.textColor = .black
//        tF.backgroundColor = .red
//        tF.font = UIFont.systemFont(ofSize: 20)
//        tF.isSecureTextEntry = true
//        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        tF.translatesAutoresizingMaskIntoConstraints = false
//        return tF
//    }()
//    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        view.backgroundColor = .darkGray
        view.addSubview(photoButton)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//
        stackView.addArrangedSubview(firstNameContainer)
        stackView.addArrangedSubview(lastNameContainer)
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(signUpButton)
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor , constant: 40).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    @objc func handleLogin(){
        print("Login button tapped")
    }
    
    @objc func handleProfilePic(){
        
    }

}
