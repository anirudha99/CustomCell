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
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    var  isEdit = false
    var initialFetch: Bool = false
    
    var chats: [Chats] = []
    var currentUser: ChatAppUser?
    
    //MARK: -Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        configureNavigationBar()
        configureNavigationBarT()
        configureUICollectionView()
        configureSpinner()
        fetchUserConvo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBarT() {
        navigationController?.navigationBar.tintColor = ColorConstants.teaGreen
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapNewMessageButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton))
    }
    
    private func configureUICollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = ColorConstants.background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func configureSpinner(){
        spinnerT.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerT)
        spinnerT.color = .white
        spinnerT.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerT.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func startSpinning(){
        spinnerT.startAnimating()
    }
    
    private func stopSpinning(){
        spinnerT.stopAnimating()
    }
    
    //MARK: -Handlers
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation,animated: true)
        }
    }
    
    @objc func didTapNewMessageButton(){
        let vc = NewConversationViewController()
        vc.chats = chats
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc,animated: true)
    }
    
    private func fetchUserConvo(){
        chats = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        DispatchQueue.main.async {
            self.startSpinning()
        }
        NetworkManager.shared.fetchCurrentUser(completion: { currentUser in
            self.currentUser = currentUser
        })
        NetworkManager.shared.fetchChats(completion: { chats in
            self.chats = chats
            DispatchQueue.main.async {
                self.stopSpinning()
                self.collectionView.reloadData()
            }
        })
    }
    
    @objc func didTapEditButton(){
        isEdit = !isEdit
        initialFetch  = true
        collectionView.reloadData()
    }
}

// MARK: - Extension : CollectionView

extension ConversationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        
        let chat = chats[indexPath.row]
        cell.chat = chat
        cell.hideCheckBoxButton(isHide: isEdit)
        cell.layer.backgroundColor = ColorConstants.background.cgColor
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

// MARK: - Extension : CollectionViewFlowLayout

extension ConversationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - Extension

extension ConversationsViewController: UserAuthenticatedDelegate {
    func userAuthenticated() {
        configureNavigationBarT()
        configureUICollectionView()
        validateAuth()
    }
}

extension ConversationsViewController: ChatSelectedDelegate {
    func chatSelected(isSelected: Bool) {
        print("Selected\(isSelected)")
    }
}
