//
//  LoginViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    
    //MARK: -Properties
    
    var emailTextField = CustomTextField(placeholder: "Enter Email")
    var passwordTextField = CustomTextField(placeholder: "Enter Password")
    
    lazy var emailContainer: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: UIImage(systemName: "lock.fill")!, textField: passwordTextField)
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    var signUpLabel = CustomLabel(text: "Don't have an account?")
    var dividerORLabel = CustomLabel(text: "------------------- OR -------------------")
    var otherOptionLabel = CustomLabel(text: "Login using ")
    
    let signupPageButton: UIButton = {
       let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transistionToSignUp), for: .touchUpInside)
        return button
    }()
    
    let signUpPageButton: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "SignUp")
        return button
    }()
    
    lazy var signUpPageTransistionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(signUpPageButton)
//        signUpPageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        signUpPageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        signUpPageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(signUpLabel)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signUpLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        signUpLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(signupPageButton)
        signupPageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signupPageButton.leftAnchor.constraint(equalTo: signUpLabel.rightAnchor, constant: 10).isActive = true
        signupPageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        return view
    }()
    
    let googleLoginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Sign in with Google", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var googleLoginContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        let googleImage = UIImageView()
        googleImage.image = UIImage(named: "google")
        view.addSubview(googleImage)
        googleImage.translatesAutoresizingMaskIntoConstraints = false
        googleImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        googleImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        googleImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        googleImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(googleLoginButton)
        googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleLoginButton.leftAnchor.constraint(equalTo: googleImage.rightAnchor).isActive = true
        googleLoginButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        googleLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return view
    }()
   
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
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

    //MARK: -Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createDismissKeyboardTapGesture()
        configureNotificationObserver()
    }
    
    func configureUI(){
        
        view.backgroundColor = .darkGray
        
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signUpPageTransistionContainer)
        stackView.addArrangedSubview(dividerORLabel)
        stackView.addArrangedSubview(otherOptionLabel)
        stackView.addArrangedSubview(googleLoginContainer)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 150).isActive = true
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
//        let controller = CollectionViewController()
//        let presentVc = UINavigationController(rootViewController: controller)
//        presentVc.modalPresentationStyle = .fullScreen
//        present(presentVc, animated: true, completion: nil)
    }
    
    @objc func transistionToSignUp(){
        print("Transistion to sign up page")
        let controller = RegistrationViewController()
        let presentVc = UINavigationController(rootViewController: controller)
        presentVc.modalPresentationStyle = .fullScreen
        present(presentVc, animated: true, completion: nil)
        
    }
    
    @objc func googleLogin(){
        print("Login button tapped")
    }
    
    @objc func facebookLogin(){
        print("Login button tapped")
    }
}
