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
    }
    
    var delegate: UserAuthenticatedDelegate?
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    let scrollView = UIScrollView()
    
    let appLogo : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: ImageConstants.appIcon)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = ColorConstants.tealGreen
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
    
    var emailTextField = CustomTextField(placeholder: "Enter Email", color: ColorConstants.black)
    var passwordTextField = CustomTextField(placeholder: "Enter Password", color: ColorConstants.black)
    
    lazy var emailContainer: InputContainerView = {
        return InputContainerView(image: ImageConstants.personFill!, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: ImageConstants.lockFill!, textField: passwordTextField)
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = ColorConstants.tealGreenDark
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorConstants.tealGreenDark
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    var signUpLabel = CustomLabel(text: "Don't have an account?", color: ColorConstants.tealGreen, font: FontConstants.senderTextfont)
    
    let signupPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(ColorConstants.teaGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transistionToSignUp), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor( ColorConstants.teaGreen, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    
    lazy var signUpPageTransistionContainer: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpLabel)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signUpLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
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
    }
    
    func configureUI(){
        
        view.backgroundColor = ColorConstants.background
        view.addSubview(scrollView)
        scrollView.addSubview(logoContainer)
        
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        stackView.addArrangedSubview(signUpPageTransistionContainer)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        logoContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        logoContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 50).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
    }
    
    func configureSpinner(){
        spinnerT.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerT)
        spinnerT.color = ColorConstants.whiteChocolate
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: -Handlers
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y == -80 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleOrientationChange() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    }
    
    @objc func handleLoginButtonTapped(_ sender: UIButton){
        sender.shake()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              isUserEntered
        else {
            showAlert(title: "Login error", message: "Please enter all information properly to Log in")
            return
        }
        startSpinning()
        //Firebase
        NetworkManager.shared.logInUsingFirebase(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
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
        }
    }
    
    @objc func handleForgotPasswordButtonTapped(_ sender: UIButton){
        sender.flash()
        let controller = ResetPasswordViewerViewController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func transistionToSignUp(_ sender: UIButton){
        sender.flash()
        let controller = RegistrationViewController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}
