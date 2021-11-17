//
//  MessageViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit

class MessageViewController: UIViewController {
    
    var MessageTableView: UITableView!
    
    var messageTextField = CustomTextField(placeholder: "Message here")
    
//    private var messages = []()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        tabBarController?.tabBar.isHidden = true
        configureNavigationBar()
        configureTableView()
        configureUI()
        createDismissKeyboardTapGesture()
        configureNotificationObserver()
      
    }
    
    func configureTableView(){
        MessageTableView = UITableView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height))
        MessageTableView.delegate = self
        MessageTableView.dataSource = self
        MessageTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(MessageTableView)
        
    }
    
    func configureUI(){
        messageTextField.textAlignment = .center
        messageTextField.layer.borderColor = UIColor.systemGray.cgColor
        messageTextField.layer.borderWidth = 1
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)
        messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20).isActive = true
        messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
            self.view.frame.origin.y -= 200
        }
    }
    
    @objc func keyboardWillHide(){
        print("Keyboard will hide")
        if view.frame.origin.y == -200 {
            self.view.frame.origin.y = 0
        }
    }
    
//    func send(message){
//        
//    }
}
extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}
