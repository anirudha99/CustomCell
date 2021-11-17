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
//        navigationItem.title = "CustomCell"
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
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc,animated: true)
    }
    
    func fetchConversations(){
        collectionView.isHidden = false
    }
    
}

extension ConversationsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
//        cell.backgroundColor = .red
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let vc = MessageViewController()
        vc.title = "Name"
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
