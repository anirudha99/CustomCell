//
//  CollectionViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 09/11/21.
//

import UIKit
import FirebaseAuth


let reuseIdentifier = "ConversationCell"

class ConversationsViewController: UIViewController {
    
    //MARK: -Properties
    var collectionView: UICollectionView!
    
    //    private let spinner = JGProgressHUD(style: .dark)
    
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    var  isEdit = false
    var initialFetch: Bool = false
    
    var chats: [Chats] = []
    var currentUser: ChatAppUser?
    
    let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .systemGray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    //MARK: -Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        configureNavigationBarT()
        configureUICollectionView()
        view.addSubview(noConversationsLabel)
        
        validateAuth()
        fetchConversations()
        fetchUserConvo()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureNavigationBarT() {
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemRed
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapNewMessageButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton))
    }
    
    func configureUICollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.isHidden = true
        collectionView.backgroundColor = .lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //    func startSpinning(){
    //        spinnerT.startAnimating()
    //    }
    //
    //    func stopSpinning(){
    //        spinnerT.stopAnimating()
    //    }
    
    //MARK: -Handlers
    
    func validateAuth(){
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation,animated: true)
        }
    }
    
    @objc func didTapNewMessageButton(){
        let vc = NewConversationViewController()
        vc.currentUser = currentUser
        vc.chats = chats
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc,animated: true)
    }
    
    func fetchUserConvo(){
        chats = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        NetworkManager.shared.fetchCurrentUser(completion: { currentUser in
            self.currentUser = currentUser
        })
        NetworkManager.shared.fetchChats(completion: { chats in
            self.chats = chats
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }

    
    @objc func didTapEditButton(){
        print("edit button tapped")
        isEdit = !isEdit
        initialFetch  = true
        collectionView.reloadData()
    }
    
    func fetchConversations(){
        collectionView.isHidden = false
    }
    
}

extension ConversationsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        
        let chat = chats[indexPath.row]
       
        cell.chat = chat
        
        //            cell.checkBox.isHidden = !isEdit
        cell.hideCheckBoxButton(isHide: isEdit)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = MessageViewController()
        vc.chat = chats[indexPath.row]

        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConversationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ConversationsViewController: UserAuthenticatedDelegate {
    func userAuthenticated() {
        configureNavigationBarT()
        configureUICollectionView()
        validateAuth()
        fetchConversations()
    }
}

extension ConversationsViewController: ChatSelectedDelegate {
    func chatSelected(isSelected: Bool) {
        print("Selected\(isSelected)")
    }
}
