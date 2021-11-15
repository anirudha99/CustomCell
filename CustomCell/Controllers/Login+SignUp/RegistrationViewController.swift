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
    //
    
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
        view.addSubview(profilePicImage)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        profilePicImage.addGestureRecognizer(gesture)
        profilePicImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profilePicImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        profilePicImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //
        stackView.addArrangedSubview(firstNameContainer)
        stackView.addArrangedSubview(lastNameContainer)
        stackView.addArrangedSubview(emailContainer)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(loginPageTransistionContainer)
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: profilePicImage.bottomAnchor , constant: 40).isActive = true
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
    
    @objc func didTapChangeProfilePic(){
        print("profilepic")
        presentPhotoActionSheet()
    }
    
    @objc func handleRegisterButtonTapped(){
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !firstName.isEmpty, !lastName.isEmpty,
              !email.isEmpty,!password.isEmpty,
              password.count >= 6
        else {
            showAlert(title: "Login error", message: "Please enter all information properly to Log in")
            return
        }
        
        //Firebase Log in
        
        DatabaseManager.shared.validateIfUserExists(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else{
                //user already exists
                strongSelf.showAlert(title: "Error", message: "User with same email address already exists!")
                return
            }
            print("Sign up button tapped")
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    strongSelf.showAlert(title: "Error", message: "Error creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func transistionToLogin(){
        print("Transistion to login page")
        let controller = LoginViewController()
        let presentVc = UINavigationController(rootViewController: controller)
        presentVc.modalPresentationStyle = .fullScreen
        present(presentVc, animated: true, completion: nil)
    }
    
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default,handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self]_ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet,animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
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
