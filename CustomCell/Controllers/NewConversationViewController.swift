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
        configureCollectionView()
        configureSpinner()
        fetchAllUser()
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
    
    func configureSearch() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.tintColor = .white
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Users"
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
        var viewControlArray = navigationController?.viewControllers
        viewControlArray?.removeLast()
        for chat in chats{
            var currentChat = chat
            let uidF = chat.users[0].userId
            let uidS = chat.users[1].userId
            if uidF == currentUser!.userId && uidS == selectedUser.userId || uidF == selectedUser.userId && uidS == currentUser!.userId {
                print("Chat already there")
                currentChat.otherUser =  uidF == currentUser!.userId ? 1 : 0
                messageVC.chat = currentChat
                viewControlArray?.append(messageVC)
                navigationController?.modalPresentationStyle = .fullScreen
                navigationController?.setViewControllers(viewControlArray!, animated: true)
//                navigationController?.pushViewController(messageVC, animated: true)
                return
            }
        }
        print("New Chat")
        NetworkManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        messageVC.chat = Chats(chatId: id, users: users, lastMessage: nil, messages: [], otherUser: 1)
        viewControlArray?.append(messageVC)
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.setViewControllers(viewControlArray!, animated: true)
//        navigationController?.pushViewController(messageVC, animated: true)
    }
}

extension NewConversationViewController:  UICollectionViewDelegateFlowLayout {
    
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


extension NewConversationViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController){
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if inSearchMode {
            resultArr.removeAll()
            
            for user in users {
                if user.firstName.lowercased().contains(searchText.lowercased()) || user.lastName.lowercased().contains(searchText.lowercased()) || user.emailAddress.lowercased().contains(searchText.lowercased()) {
                    resultArr.append(user)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
    }
}
