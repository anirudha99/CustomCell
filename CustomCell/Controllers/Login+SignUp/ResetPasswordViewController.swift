//
//  ViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 09/11/21.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewerViewController: UIViewController {
    let scrollView = UIScrollView()
    
    var emailTextField = CustomTextField(placeholder: "Enter Email", color: ColorConstants.tealGreen)
    var emailLabel = CustomLabel(text: "Enter your email address to reset password!", color: ColorConstants.teaGreen, font: FontConstants.senderTextfont)
    
    lazy var emailContainer: InputContainerView = {
        return InputContainerView(image: ImageConstants.personFill!, textField: emailTextField)
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(handleForgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
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
        createDismissKeyboardTapGesture()
        configureNotificationObserver()
    }
    
    func configureUI(){
        navigationItem.backButtonDisplayMode = .minimal
        view.backgroundColor = ColorConstants.background
        view.addSubview(scrollView)
        emailLabel.lineBreakMode = .byWordWrapping
        emailLabel.numberOfLines = 2
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(forgotPasswordButton)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
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
    
    @objc func handleForgotPasswordButtonTapped(){
        guard let email = emailTextField.text else { return }
        if emailValidation(email: email){
            NetworkManager.shared.resetPasswordWithEmail(email: email) { result in
                if result == "LinkSent" {
                    self.showAlertWithCancel(title: "Password Reset Email Sent", message: "Reset link is sent to your registered email, please check your email", buttonText: "OK") {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else{
                    self.showAlert(title: "Failed to send link", message: "Please try again later")
                }
            }
        } else {
            showAlert(title: "Invalid email address", message: MessageConstants.emailInvalid)
        }
    }
}

