//
//  NewConversationViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    //MARK: - Properties
    
    var currentUser: ChatAppUser?
    var chats: [Chats] = []
    var users: [ChatAppUser] = []
    var resultArr: [ChatAppUser] = []
    
    
    let cellSpacingHeight: CGFloat = 20
    
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var collectionView: UICollectionView!
    
    private var inSearchMode: Bool {
        return !searchController.searchBar.text!.isEmpty
    }
    
//    private let tableView: UITableView = {
//        let table = UITableView()
//        table.isHidden = true
//        table.register(UserCell.self, forCellReuseIdentifier: "cell")
//        return table
//    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No search results"
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureNavBar()
//        configureTableView()
        configureSpinner()
        fetchAllUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
//        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.frame.width / 4, y: (view.frame.height-200) / 2, width: view.frame.width / 2, height: 200)
    }
    
    //MARK: -Handlers
    
    func configureNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
        //        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemRed
        
        //        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dissmissScreen))
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
//    func configureTableView(){
//        view.addSubview(tableView)
//        view.addSubview(noResultsLabel)
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
    
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
    
    @objc func dissmissScreen(){
        dismiss(animated: true, completion: nil)
    }
    
    func fetchAllUser(){
        NetworkManager.shared.fetchAllUsers { users in
            self.users = users
            print(users)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - Extensions

extension NewConversationViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ?  resultArr.count : users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        
        cell.backgroundColor = .white
        collectionView.isHidden = false
        noResultsLabel.isHidden = true
        
        let user = inSearchMode ? resultArr[indexPath.row] : users[indexPath.row]
        
        cell.titleLabel.text = "\(user.firstName) \(user.lastName)"
        cell.messageLabel.text = user.emailAddress
        cell.timeLabel.isHidden = true
        cell.checkBox.isHidden = true
        let uid = user.userId
        
        NetworkManager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.iconImageView.image = image
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        let users: [ChatAppUser] = [currentUser!, selectedUser]
        let id = "\(currentUser!.userId)_\(selectedUser.userId)"
        let messageVC = MessageViewController()
        
        for chat in chats{
            var currentChat = chat
            let uidF = chat.users[0].userId
            let uidS = chat.users[1].userId
            if uidF == currentUser!.userId && uidS == selectedUser.userId || uidF == selectedUser.userId && uidS == currentUser!.userId {
                print("Chat already there")
                currentChat.otherUser =  uidF == currentUser!.userId ? 1 : 0
                messageVC.chat = currentChat
                
                navigationController?.pushViewController(messageVC, animated: true)
            }
        }
    }
}


extension NewConversationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if inSearchMode {
                   resultArr.removeAll()
            for user in users {
                if user.firstName.lowercased().contains(searchText.lowercased()) |
        
        if !searchText.isEmpty {
            searching = true
            resultArr.removeAll()
            resultArr = users.filter({$0.firstName.prefix(count!).lowercased() == searchText.lowercased()})
        }
        else{
            searching = false
            resultArr.removeAll()
//            resultArr = users
        }
        tableView.reloadData()
    }
}
