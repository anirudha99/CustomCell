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
    
    var isUserEntered : Bool {
        return !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
        //        password.count >= 6
    }
    
    var delegate: UserAuthenticatedDelegate?
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    let appLogo : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: ImageConstants.appIcon)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50
        return iv
    }()
    
    lazy var logoContainer: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 50
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
    
    let signupPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transistionToSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpPageTransistionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        configureSpinner()
        
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
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 150).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    func configureSpinner(){
        spinnerT.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerT)
        spinnerT.color = .white
        spinnerT.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerT.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startSpinning(){
        spinnerT.startAnimating()
    }
    
    func stopSpinning(){
        spinnerT.stopAnimating()
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
        print("Keyboard will show")
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(){
        print("Keyboard will hide")
        if view.frame.origin.y == -80 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleLoginButtonTapped(){
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              isUserEntered
        else {
            showAlert(title: "Login error", message: "Please enter all information properly to Log in")
            return
        }
        //        spinner.show(in: view)
        startSpinning()
        //Firebase
        print("Login button tapped")
        NetworkManager.shared.logInUsingFirebase(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                //                strongSelf.spinner.dismiss()
                strongSelf.stopSpinning()
            }
            if error != nil {
                self?.showAlert(title: "Error", message: " Login Error")
                return
            }
            else{
                self?.delegate?.userAuthenticated()
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
            UserDefaults.standard.set(email,forKey: "email")
        }
    }
    
    @objc func transistionToSignUp(){
        print("Transistion to sign up page")
        let controller = RegistrationViewController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
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
