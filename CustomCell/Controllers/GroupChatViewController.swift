//
//  VideoPlayerViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit


class GroupChatViewController: UIViewController {
    
    let reuseIdentifier = "ConversationCell"
    var users: [ChatAppUser] = []
    var groupCollectionView: UICollectionView!
    var selectedUsers: [IndexPath] = []
    var currentUser: ChatAppUser!
    
    let groupPhotoLabel = CustomLabel(text: "Group Photo")
    let groupPhoto = CustomImageView(image: ImageConstants.groupPhoto!, height: 100, width: 100, cornerRadius: 45, color: .white)
    let groupNameLabel = CustomLabel(text: "Group Name")
    let groupName = CustomTextField(placeholder: "Enter Group Name")
    
    lazy var groupNameContainer: InputContainerView = {
        return InputContainerView(image: ImageConstants.groupPhoto!, textField: groupName)
    }()
    
    let selectUsersLabel = CustomLabel(text: "Select Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        fetchAllUser()
    }
    
    func configureCollectionView(){
        groupCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(groupCollectionView)
        groupCollectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        groupCollectionView.dataSource = self
        groupCollectionView.delegate = self
        groupCollectionView.alwaysBounceVertical = true
        groupCollectionView.isUserInteractionEnabled = true
        //        groupCollectionView.keyboardDismissMode = .interactive
        //        groupCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        //        groupCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        groupCollectionView.register(ConversationCell.self, forCellWithReuseIdentifier: collectIdentifier)
        
    }
    
    func configureUI(){
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handleCreate))
        navigationItem.rightBarButtonItems = [createButton]
        navigationItem.title = "Create Group Chat"
        navigationItem.backButtonTitle = ""
        
        groupPhoto.layer.borderWidth = 1
        groupPhoto.layer.borderColor = UIColor.systemRed.cgColor
        groupPhoto.clipsToBounds = true
        groupPhoto.isUserInteractionEnabled = true
        groupPhoto.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        groupPhoto.addGestureRecognizer(tapGesture)
        
        view.addSubview(groupPhotoLabel)
        view.addSubview(groupPhoto)
        view.addSubview(groupNameLabel)
        view.addSubview(groupNameContainer)
        view.addSubview(selectUsersLabel)
        
        groupPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        groupPhoto.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        groupNameContainer.translatesAutoresizingMaskIntoConstraints = false
        selectUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        groupCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            groupPhotoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupPhotoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupPhoto.topAnchor.constraint(equalTo: groupPhotoLabel.bottomAnchor, constant: 5),
            groupPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupNameLabel.topAnchor.constraint(equalTo: groupPhoto.bottomAnchor, constant: 20),
            groupNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupNameContainer.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 5),
            groupNameContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            groupNameContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            selectUsersLabel.topAnchor.constraint(equalTo: groupNameContainer.bottomAnchor, constant: 20),
            selectUsersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupCollectionView.topAnchor.constraint(equalTo: selectUsersLabel.bottomAnchor, constant: 5),
            groupCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            groupCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            groupCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleCreate(){
        let resultValidation = validateGroupChat(groupPhoto: groupPhoto.image!, groupName: groupName.text!, selectedUsersCount: selectedUsers.count)
        if resultValidation == "" {
            let messageVC = MessageViewController()
            var vcArray = navigationController?.viewControllers
            vcArray?.removeLast()
            vcArray?.removeLast()
            let chatID = "\(groupName.text!)_\(UUID())"
            let groupPhotoPath = "Profile/\(chatID)"
            var usersList: [ChatAppUser] = []
            usersList.append(currentUser)
            for indexPath in selectedUsers {
                let user = users[indexPath.row]
                usersList.append(user)
            }
            ImageUploader.uploadImage(image: groupPhoto.image!, name: groupPhotoPath) { url in
                
            }
            NetworkManager.shared.addChat(users: usersList, id: chatID, isGroupChat: true, groupName: groupName.text, groupIconPath: groupPhotoPath)
            messageVC.chat = Chats(chatId: groupPhotoPath, users: usersList, lastMessage: nil, messages: [], isGroupChat: true, groupName: groupName.text)
            vcArray?.append(messageVC)
            navigationController?.setViewControllers(vcArray!, animated: true)
        }
        else {
            showAlert(title: "Creation Failed", message: resultValidation)
        }
    }
    
    func validateGroupChat(groupPhoto: UIImage, groupName: String, selectedUsersCount: Int) -> String {
        if groupPhoto == ImageConstants.groupPhoto {
            return MessageConstants.groupPhotoInvalid
        }
        if groupName.count < 3 {
            return MessageConstants.groupNameInvalid
        }
        if selectedUsersCount < 1 {
            return MessageConstants.minimumGroupMemberError
        }
        return ""
    }
    
    func fetchAllUser() {
        NetworkManager.shared.fetchAllUsers() { users in
            self.users = users
            DispatchQueue.main.async {
                self.groupCollectionView.reloadData()
            }
        }
    }
}

extension GroupChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        let userObject = users[indexPath.item]
        cell.titleLabel.text = userObject.emailAddress
        cell.messageLabel.text = "\(userObject.firstName) \(userObject.lastName) "
        cell.timeLabel.isHidden = true
        cell.checkBox.isHidden = true
        if selectedUsers.contains(indexPath){
            cell.backgroundColor = .systemRed
        }
        else {
            cell.backgroundColor = .lightGray
        }
        NetworkManager.shared.downloadImageWithPath(path: "Profile/\(userObject.userId)") { image in
            cell.iconImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell: UICollectionViewCell = groupCollectionView.cellForItem(at: indexPath)!
        if selectedUsers.contains(indexPath) {
            selectedUsers.remove(at: selectedUsers.firstIndex(of: indexPath)!)
            selectedCell.backgroundColor = .white
        } else {
            selectedUsers.append(indexPath)
            selectedCell.backgroundColor = .lightGray
        }
    }
    
}

extension GroupChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GroupChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            groupPhoto.image = imageSelected
            groupPhoto.layer.borderColor = UIColor.systemRed.cgColor
            groupPhoto.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
}
