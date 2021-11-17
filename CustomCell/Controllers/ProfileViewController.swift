//
//  ProfileViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit
import FirebaseAuth
import CloudKit

let cellIdentifier = "cell"

class ProfileViewController: UIViewController {
    
    
    //MARK: -Properties
    var profileTableView: UITableView!
    
    let data = ["Log Out"]
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarT()
        configureTableView()
        
        view.backgroundColor = .systemGray4
    }
    
    func configureNavigationBarT() {
        view.backgroundColor = .red
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonTapped))
        //        navigationItem.title = "CustomCell"
    }
    
    func configureTableView(){
        profileTableView = UITableView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height))
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(profileTableView)
        profileTableView.tableHeaderView = createTableHeader()
        
    }
    
    //MARK: -Handlers
    
    func createTableHeader() -> UIView? {
        //uses email from login
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/"+fileName
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        headerView.backgroundColor = .systemGray
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.width-150) / 2, y: 75, width: 150, height: 150))
        
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path) { result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: imageView, url: url)
            case.failure(let error):
                print("Failed to download url \(error) ")
            }
        }
        
        return headerView
    }
    
    //downloads the image using url and sets the image in profile
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
    
    @objc func logoutButtonTapped(){
        let loggingOut = {
            let isSignedOut  = NetworkManager.shared.logout()
            if isSignedOut {
                self.transistionToLoginScreen()
            }
        }
        showAlertWithCancel(title: "Logging Out", message: "Are you sure?", buttonText: "Logout", buttonAction: loggingOut)
    }
    
    func transistionToLoginScreen(){
        let vc = LoginViewController()
        let navigation = UINavigationController(rootViewController: vc)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation,animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        //        cell.backgroundColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
