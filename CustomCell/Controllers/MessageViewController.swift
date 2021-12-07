//
//  MessageViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit

let collectIdentifier = "ConversationCell"
let imageCollectIdentifier = "ImageCell"

class MessageViewController: UIViewController {
    
    var chat: Chats!
    var messages: [Message] = []
    
    var isNewConversation = false
    var otherUser: ChatAppUser!
    var currentUser: ChatAppUser!
    let uid = NetworkManager.shared.getUID()
    
    let containerView = UIView()
    
    var MessageTableView: UITableView!
    var messageCollectionView: UICollectionView!
    
    var messageTextField = CustomTextField(placeholder: "Type Message here")
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65)
        containerView.backgroundColor = .white
        
        let sendButton: UIButton = {
            let button = UIButton()
            button.setImage(ImageConstants.sendButton, for: .normal)
            button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
            button.tintColor = .systemRed
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            return button
        }()
        
        let picButton: UIButton = {
            let button = UIButton()
            button.setImage(ImageConstants.picture, for: .normal)
            button.addTarget(self, action: #selector(picButtonTapped), for: .touchUpInside)
            button.tintColor = .systemRed
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .white
            return button
        }()
        
        self.messageTextField.layer.cornerRadius = 12
        self.messageTextField.layer.borderColor = UIColor.systemGray.cgColor
        self.messageTextField.layer.borderWidth = 1
        self.messageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(self.messageTextField)
        containerView.addSubview(sendButton)
        containerView.addSubview(picButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        
        picButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -5).isActive = true
        picButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        picButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        picButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        
        self.messageTextField.rightAnchor.constraint(equalTo: picButton.leftAnchor, constant: -5).isActive = true
        self.messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 5).isActive = true
        self.messageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        self.messageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        fetchChats()
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func configureCollectionView(){
        messageCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(messageCollectionView)
        messageCollectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageCollectionView.dataSource = self
        messageCollectionView.delegate = self
        messageCollectionView.alwaysBounceVertical = true
        messageCollectionView.isUserInteractionEnabled = true
        messageCollectionView.keyboardDismissMode = .interactive
        messageCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        messageCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        messageCollectionView.register(MessageViewCell.self, forCellWithReuseIdentifier: collectIdentifier)
        messageCollectionView.register(ImageMessageViewCell.self, forCellWithReuseIdentifier: imageCollectIdentifier)
    }
    
    func configureUI(){
        var name: String
        NetworkManager.shared.fetchCurrentUser { user in
            self.currentUser = user
        }
        if chat.isGroupChat {
            name = chat.groupName!
        } else {
            if chat.users[0].userId == uid {
                name = "\(chat.users[1].firstName) \(chat.users[1].lastName)"
            } else {
                name = "\(chat.users[0].firstName) \(chat.users[0].lastName)"
            }
        }
        
        navigationItem.title = name
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissAndGoHome))
    }
    
    
    @objc func dismissAndGoHome(){
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sendButtonTapped(){
        if messageTextField.text != "" {
            let newMessage = Message(sender: currentUser.userId, content: messageTextField.text!, time: Date(), seen: false, imagePath: "")
            var messagesArray = messages
            messagesArray.append(newMessage)
            NetworkManager.shared.addMessages(messages: messagesArray, lastMessage: newMessage, id: chat.chatId!)
            messageTextField.text = ""
        }
    }
    
    @objc func picButtonTapped(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    public func fetchChats(){
        messages = []
        NetworkManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            self.messages = messages
            DispatchQueue.main.async {
                self.messageCollectionView.reloadData()
            }
        }
    }
    
    private func uploadPhotoToSend(image: UIImage){
        let imagePath = "Chats/\(chat.chatId!)/\(UUID())"
        let newMessage = Message(sender: currentUser.userId, content: "", time: Date(), seen: false, imagePath: imagePath)
        var messagesArray = self.messages
        messagesArray.append(newMessage)
        ImageUploader.uploadImage(image: image, name: imagePath) { url in }
        NetworkManager.shared.addMessages(messages: messagesArray, lastMessage: newMessage, id: chat.chatId!)
        self.messageCollectionView.reloadData()
    }
    
    
}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let messageObj = messages[indexPath.item]
        
        if messageObj.imagePath == "" {
            let cell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: collectIdentifier, for: indexPath) as! MessageViewCell
            cell.messageItem = messageObj
            cell.usersArray = chat.users
            return cell
        }
        else{
            let cell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: imageCollectIdentifier, for: indexPath) as! ImageMessageViewCell
            
            cell.messageItem = messageObj
            cell.usersArray = chat.users
            NetworkManager.shared.downloadImageWithPath(path: messageObj.imagePath!) { image in
                DispatchQueue.main.async {
                    cell.imageChat.image = image
                }
            }
            return cell
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        messageCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MessageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let messageobj = messages[indexPath.row]
        var height: CGFloat = CGFloat()
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let imageFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        let estimateSizeCell = MessageViewCell(frame: frame)
        let estimateImageSizeCell = ImageMessageViewCell(frame: imageFrame)
        
        if messageobj.imagePath == "" {
            estimateSizeCell.messageItem = messages[indexPath.row]
            estimateSizeCell.layoutIfNeeded()
            let targetSize = CGSize(width: view.frame.width, height: 1000)
            let estimatedSize = estimateSizeCell.systemLayoutSizeFitting(targetSize)
            height = estimatedSize.height + 20
        }
        else{
            estimateImageSizeCell.messageItem = messages[indexPath.row]
            estimateImageSizeCell.layoutIfNeeded()
            let targetSize = CGSize(width: view.frame.width, height: 1000)
            let estimatedSize = estimateImageSizeCell.systemLayoutSizeFitting(targetSize)
            height = estimatedSize.height + 30
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
}

extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadPhotoToSend(image: imageSelected)
        }
        dismiss(animated: true, completion: nil)
    }
}
