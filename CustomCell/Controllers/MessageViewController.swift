//
//  MessageViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit

struct ChatMessage {
    var sender: String?
    let text: String
    let isIncoming: Bool
    let date: Date
    var seen: Bool?
}

class MessageViewController: UIViewController {
    
    
    var chat: Chats!
    var messages: [Message] = []
    
    var isNewConversation = false
    var otherUser: ChatAppUser!
    var currentUser: ChatAppUser!
    var chatId: String?
    
    var MessageTableView: UITableView!
    
    var messageTextField = CustomTextField(placeholder: "Type Message here")
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    //    private var messages = []()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
        configureTableView()
        configureUI()
        createDismissKeyboardTapGesture()
        configureNotificationObserver()
        fetchChats()
    }
    
    
    func configureTableView(){
        MessageTableView = UITableView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height-120))
        MessageTableView.separatorStyle = .none
        MessageTableView.delegate = self
        MessageTableView.dataSource = self
        MessageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        MessageTableView.isUserInteractionEnabled = true
        view.addSubview(MessageTableView)
    }
    
    func configureUI(){
        
        
        
        messageTextField.layer.cornerRadius = 12
        messageTextField.layer.borderColor = UIColor.systemGray.cgColor
        messageTextField.layer.borderWidth = 1
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)
        view.addSubview(sendButton)
        
        chatId = "\(chat.users[0].userId)_\(chat.users[1].userId)"
        if chat.otherUser == 0 {
            otherUser = chat.users[0]
            currentUser = chat.users[1]
        } else {
            otherUser = chat.users[1]
            currentUser = chat.users[0]
        }
        
        navigationItem.title = "\(otherUser.firstName) \(otherUser.lastName)"
        navigationItem.backButtonTitle = ""
        
        NSLayoutConstraint.activate([
            
            messageTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            messageTextField.heightAnchor.constraint(equalToConstant: 50),
//            messageTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
            
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5),
            
        ])
        
    }
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(){
        print("Keyboard will show")
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y = -280
        }
    }
    
    @objc func keyboardWillHide(){
        print("Keyboard will hide")
        if view.frame.origin.y == -280 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func sendButtonTapped(){
        print("send button tapped")
        if messageTextField.text != "" {
            let newMessage = Message(sender: currentUser.userId, content: messageTextField.text!, time: Date(), seen: false)
            var messagesArray = messages
            messagesArray.append(newMessage)
            NetworkManager.shared.addMessages(messages: messagesArray, lastMessage: newMessage, id: chatId!)
            messageTextField.text = ""
        }
    }
    
    func fetchChats(){
        messages = []
        NetworkManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            //print("Messages\(messages)")
            self.messages = messages
            
            DispatchQueue.main.async {
                self.MessageTableView.reloadData()
            }
        }
    }
}
extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        
        cell.messageItem = messages[indexPath.row]
        return cell
    }
}
