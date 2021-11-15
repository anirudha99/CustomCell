//
//  LoginViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: -Properties
    
    let appLogo : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: ImageConstants.appIcon)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        return iv
    }()
    
    lazy var logoContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        container.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        container.addSubview(appLogo)
        appLogo.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        appLogo.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        appLogo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        appLogo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return container
    }()
    
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
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    var signUpLabel = CustomLabel(text: "Don't have an account?")
    var dividerORLabel = CustomLabel(text: "------------------- OR -------------------")
    var otherOptionLabel = CustomLabel(text: "Login with")
    
    let signupPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transistionToSignUp), for: .touchUpInside)
        return button
    }()
    
    //    let signUpPageButton: UIButton = {
    //        let button = UIButton()
    //        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "SignUp")
    //        return button
    //    }()
    
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
    
    //MARK: -Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createDismissKeyboardTapGesture()
        configureNotificationObserver()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func configureUI(){
        
        view.backgroundColor = .darkGray
        
        view.addSubview(logoContainer)
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logoContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 140).isActive = true
        
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
    
    @objc func handleLoginButtonTapped(){
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,!password.isEmpty, password.count >= 6
        else {
            showAlert(title: "Login error", message: "Please enter all information properly to Log in")
            return
        }
        //Firebase
        print("Login button tapped")
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                self?.showAlert(title: "Error", message: " Login Error")
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            let controller = ConversationsViewController()
            let presentVc = UINavigationController(rootViewController: controller)
            presentVc.modalPresentationStyle = .fullScreen
            self?.present(presentVc, animated: true, completion: nil)
        }
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


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
        handleLoginButtonTapped()
        }
        return true
    }
}
