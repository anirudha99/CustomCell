//
//  ProfileViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit
import FirebaseAuth
import CloudKit

let cellIdentifier = "cell"

class ProfileViewController: UIViewController {
    
    //MARK: -Properties
    
    let username = CustomLabel(text: "")
    let emailLabel = CustomLabel(text: "")
    let imageView = UIImageView()
  
    var currentUser: ChatAppUser?
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarT()
        configureProfileUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserData()
       
    }
    
    private func configureNavigationBarT() {
        view.backgroundColor = UIColor(white: 0.85, alpha: 1)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonTapped))
    }
    
    //MARK: -Handlers
    private func configureProfileUI(){
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        imageView.addGestureRecognizer(tapGesture)
        
        username.backgroundColor = .darkGray
        username.layer.masksToBounds = true
        username.layer.cornerRadius = 10
        username.layer.borderColor = UIColor.black.cgColor
        username.layer.borderWidth = 2
        username.font = UIFont.boldSystemFont(ofSize: 18)
        username.textColor = .white
        emailLabel.backgroundColor = .darkGray
        emailLabel.layer.masksToBounds = true
        emailLabel.layer.cornerRadius = 10
        emailLabel.layer.borderColor = UIColor.black.cgColor
        emailLabel.font = UIFont.boldSystemFont(ofSize: 18)
        emailLabel.layer.borderWidth = 2
        emailLabel.textColor = .white
        
        view.addSubview(username)
        view.addSubview(emailLabel)
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        username.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 10).isActive = true
        username.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 80).isActive = true
        username.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -80).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: username.bottomAnchor,constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 80).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -80).isActive = true
        
    }
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func fetchUserData() {
        NetworkManager.shared.fetchCurrentUser() { user in
            self.username.text = "Username - \(user.firstName)" + " "+"\(user.lastName)"
            self.emailLabel.text = "Email - \(user.emailAddress)"

            self.currentUser = user
            
            NetworkManager.shared.downloadImageWithPath(path: user.profileURL) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    @objc func logoutButtonTapped(){
        let loggingOut = {
            let isSignedOut  = NetworkManager.shared.logout()
            if isSignedOut {
                self.transistionToLoginScreen()
            }
        }
        showAlertWithCancel(title: "Logging Out", message: "Are you sure?", buttonText: "Logout", buttonAction: loggingOut)
    }
    
    private func transistionToLoginScreen(){
        let vc = LoginViewController()
        let navigation = UINavigationController(rootViewController: vc)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation,animated: true)
    }
    
    private func uploadNewProfile(image: UIImage) {
        let userid = NetworkManager.shared.getUID()!
        let imagePath = "Profile/\(userid)"
        ImageUploader.uploadImage(image: image, name: imagePath) { url in
            self.currentUser?.profileURL = url
            NetworkManager.shared.addUser(user: self.currentUser!)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = imageSelected
            uploadNewProfile(image: imageSelected)
        }
        dismiss(animated: true, completion: nil)
    }
}
