//
//  CollectionViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 09/11/21.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "ConversationCell"

class ConversationsViewController: UIViewController {
    
    //MARK: -Properties
    var collectionView: UICollectionView!
    
//    private let spinner = JGProgressHUD(style: .dark)
    
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    //MARK: -Init

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureNavigationBar()
        configureUICollectionView()
        validateAuth()

    }

    
    func configureNavigationBar() {
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationItem.title = "CustomCell"
    }
    
    func configureUICollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
//        collectionView.isHidden = true
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
    
    func fetchConversations(){
        
    }
}

extension ConversationsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
//        cell.backgroundColor = .red
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let vc = ChatViewController()
//        vc.title = "Name"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
}

extension ConversationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
