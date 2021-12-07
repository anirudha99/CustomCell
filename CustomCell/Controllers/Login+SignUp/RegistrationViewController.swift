//
//  RegistrationViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 10/11/21.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    //MARK: -Properties
    
    var delegate: UserAuthenticatedDelegate?
    
    var spinnerT = UIActivityIndicatorView(style: .large )
    let scrollView = UIScrollView()
    
    let profilePicImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        imageView.layer.cornerRadius = 60
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemRed
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.isUserInteractionEnabled = true
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
        loginLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(loginPageButton)
        loginPageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginPageButton.leftAnchor.constraint(equalTo: loginLabel.rightAnchor).isActive = true
        loginPageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let loginPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.red, for: .normal)
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
        configureSpinner()
    }
    
    func configureUI(){
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .darkGray
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(profilePicImage)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        profilePicImage.addGestureRecognizer(gesture)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profilePicImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profilePicImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        profilePicImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        profilePicImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //
        stackView.addArrangedSubview(firstNameContainer)
        stackView.addArrangedSubview(lastNameContainer)
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(loginPageTransistionContainer)
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: profilePicImage.bottomAnchor , constant: 40).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        
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
    
    @objc func handleOrientationChange() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
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
    
    @objc func didTapChangeProfilePic(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    
    @objc func handleRegisterButtonTapped(){
        guard profilePicImage.image != nil else { return }
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !firstName.isEmpty, !lastName.isEmpty,!email.isEmpty,!password.isEmpty,
              password.count >= 6
        else {
            showAlert(title: "Login error", message: "Please enter all information properly to Log in")
            return
        }
        
        //Firebase Log in
        DispatchQueue.main.async {
            self.startSpinning()
        }
        
        NetworkManager.shared.signup(withEmail: email, password: password) { [weak self] authResult, error in
            guard authResult != nil, error == nil else {
                self?.showAlert(title: "Error", message: "Error creating user!")
                return
            }
            if let authResult = authResult {
                let userid = authResult.user.uid
                let path = "Profile/\(userid)"
                ImageUploader.uploadImage(image: self!.profilePicImage.image!, name: path) { url in
                    
                }
                let chatUser = ChatAppUser(userId: userid, firstName: firstName, lastName: lastName, emailAddress: email, profileURL: path)
                NetworkManager.shared.addUser(user: chatUser)
//                self?.delegate?.userAuthenticated()
                DispatchQueue.main.async {
                    self?.stopSpinning()
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func transistionToLogin(){
        let controller = LoginViewController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profilePicImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
