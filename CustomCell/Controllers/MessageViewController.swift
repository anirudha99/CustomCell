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
    
    let messagesFromServer = [
        ChatMessage(text: "first message", isIncoming: true, date: Date.dateFromCustomString(customString: "18/11/2021")),
        ChatMessage(text: "Providing some text so that it repeats Providing some text so that it repeats", isIncoming: true, date: Date.dateFromCustomString(customString: "18/11/2021")),
        ChatMessage(text: "Providing some text so that it repeats Providing some text so that it repeats Providing some text so that it repeats Providing some text so that it repeats", isIncoming: false, date: Date.dateFromCustomString(customString: "19/11/2021")),
        ChatMessage(text: "hey", isIncoming: false, date: Date.dateFromCustomString(customString: "19/11/2021")),
        ChatMessage(text: "first message", isIncoming: true, date: Date.dateFromCustomString(customString: "19/11/2021")),
        ChatMessage(text: "hello", isIncoming: false, date: Date.dateFromCustomString(customString: "20/11/2021")),
    ]
    
    var chatMessages = [[ChatMessage]]()
    
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
//        attemptToAssembleGroupMessages()
        
    }
    
//    fileprivate func attemptToAssembleGroupMessages(){
//        print("Attempt to group messsages")
//
//        let groupedMessages = Dictionary(grouping: messagesFromServer) { element in
//            return element.date
//        }
//
//        //provide sorting for keys
//        let sortedKeys = groupedMessages.keys.sorted()
//        sortedKeys.forEach { (key) in
//            let values = groupedMessages[key]
//            chatMessages.append(values ?? [])
//        }
//    }
    
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
        
        let stack = UIStackView(arrangedSubviews: [messageTextField,sendButton])
        stack.axis = .horizontal
        stack.spacing = 3
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
//    class DateHeaderLabel: UILabel {
//
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            backgroundColor = .black
//            textColor = .white
//            textAlignment = .center
//            font = UIFont.boldSystemFont(ofSize: 14)
//            translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        override var intrinsicContentSize: CGSize{
//            let originalContentSize = super.intrinsicContentSize
//            let height = originalContentSize.height + 10
//            let width = originalContentSize.width + 16
//            layer.cornerRadius = height / 2
//            layer.masksToBounds = true
//            return CGSize(width: width, height: height )
//        }
//    }
}
extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatMessages[section].count
        return messages.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return chatMessages.count
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if let firstMessageInSection = chatMessages[section].first {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//            let dateString = dateFormatter.string(from: firstMessageInSection.date)
//
//            let label = DateHeaderLabel()
//            label.text = dateString
//
//            let containerView = UIView()
//            containerView.addSubview(label)
//            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//            return containerView
//        }
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        //        cell.backgroundColor = .red
//        let chatMessage = chatMessages[indexPath.section][indexPath.row]
//        cell.chatMessage = chatMessage
        cell.messageItem = messages[indexPath.row]
        return cell
    }
}
