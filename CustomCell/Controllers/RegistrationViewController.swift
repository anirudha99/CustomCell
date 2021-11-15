//
//  RegistrationViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    //MARK: -Properties
    
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
    var loginLabel = CustomLabel(text: "Already have an account?")
    
    lazy var firstNameContainer: InputContainerView = {
        firstNameTextField.keyboardType = .default
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: firstNameTextField)
    }()
    
    lazy var lastNameContainer: InputContainerView = {
        lastNameTextField.keyboardType = .default
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: lastNameTextField)
    }()
    
    lazy var emailContainer: InputContainerView = {
        emailTextField.keyboardType = .emailAddress
        return InputContainerView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: UIImage(systemName: "lock.fill")!, textField: passwordTextField)
    }()
    
    lazy var loginPageTransistionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(loginPageButton)
        loginPageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginPageButton.leftAnchor.constraint(equalTo: loginLabel.rightAnchor, constant: 10).isActive = true
        loginPageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return view
    }()
    
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
    
    let loginPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.red, for: .normal)
//        button.tintColor = .white
        button.addTarget(self, action: #selector(transistionToLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    //MARK: -Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObserver()
        createDismissKeyboardTapGesture()
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
        stackView.addArrangedSubview(loginPageTransistionContainer)
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor , constant: 40).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: -Handlers
    
    @objc func keyboardWillShow(){
        print("Keybaord will show")
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(){
        print("Keybaord will hide")
        if view.frame.origin.y == -80 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleLogin(){
        print("Login button tapped")
    }
    
    @objc func handleProfilePic(){
        
    }
    
    @objc func transistionToLogin(){
        print("Transistion to login page")
        let controller = LoginViewController()
        let presentVc = UINavigationController(rootViewController: controller)
        presentVc.modalPresentationStyle = .fullScreen
        present(presentVc, animated: true, completion: nil)
    }

}
