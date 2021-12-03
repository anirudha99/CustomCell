//
//  MessageViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit

let collectIdentifier = "ConversationCell"

class MessageViewController: UIViewController {
    
    var chat: Chats!
    var messages: [Message] = []
    
    var isNewConversation = false
    var otherUser: ChatAppUser!
    var currentUser: ChatAppUser!
    var chatId: String?
    
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
//        configureTableView()
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
    }
    
//    func configureTableView(){
//        MessageTableView = UITableView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height-120))
//        MessageTableView.separatorStyle = .none
//        MessageTableView.delegate = self
//        MessageTableView.dataSource = self
//        MessageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
//        MessageTableView.isUserInteractionEnabled = true
//        MessageTableView.keyboardDismissMode = .interactive
//        MessageTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        MessageTableView.alwaysBounceVertical = true
//        view.addSubview(MessageTableView)
//    }
//
    func configureUI(){
        chatId = "\(chat.users[0].userId)_\(chat.users[1].userId)"
        if chat.otherUser == 0 {
            otherUser = chat.users[0]
            currentUser = chat.users[1]
        } else {
            otherUser = chat.users[1]
            currentUser = chat.users[0]
        }
        
        navigationItem.title = "\(otherUser.firstName) \(otherUser.lastName)"
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
            NetworkManager.shared.addMessages(messages: messagesArray, lastMessage: newMessage, id: chatId!)
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
//                self.MessageTableView.reloadData()
                self.messageCollectionView.reloadData()
            }
        }
    }
    
    private func uploadPhotoToSend(image: UIImage){
        let imagePath = "Chats/\(chatId!)/\(UUID())"
        let newMessage = Message(sender: currentUser.userId, content: "", time: Date(), seen: false, imagePath: imagePath)
        var messagesArray = self.messages
        messagesArray.append(newMessage)
        ImageUploader.uploadImage(image: image, name: imagePath) { url in }
        NetworkManager.shared.addMessages(messages: messagesArray, lastMessage: newMessage, id: chatId!)
//        self.MessageTableView.reloadData()
        self.messageCollectionView.reloadData()
    }
}

//extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = MessageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
//        cell.messageItem = messages[indexPath.row]
//        return cell
//    }
    
    private func estimateTextFrame(text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "San Francisco Pro Display", size: 20) ?? UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height: CGFloat = CGFloat()
//
//        let messageobj = messages[indexPath.row]
//
//        if messageobj.imagePath == ""{
//            let textString = messageobj.content
//            height = estimateTextFrame(text:textString).height + 20
//        } else {
//            height = 220
//        }
//        return height
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        return headerView
//    }
//}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: collectIdentifier, for: indexPath) as! MessageViewCell
        let messageObj = messages[indexPath.item]
        cell.messageItem = messageObj
        let textS = messageObj.content
        cell.widthConstraint?.constant = estimateTextFrame(text: textS).width + 30
        return cell
    }
    
}

extension MessageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = CGFloat()
        
        let messageobj = messages[indexPath.row]
        
        if messageobj.imagePath == ""{
            let textString = messageobj.content
            height = estimateTextFrame(text:textString).height + 32
            
        } else {
            height = 220
        }
        
        return CGSize(width: view.frame.width, height: height)
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
