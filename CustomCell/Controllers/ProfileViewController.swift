//
//  ProfileViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit
import FirebaseAuth

let cellIdentifier = "cell"

class ProfileViewController: UIViewController {

    
    //MARK: -Properties
    var profileTableView: UITableView!
    
    let data = ["Log Out"]
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        
        view.backgroundColor = .systemGray4
    }

    func configureNavigationBar() {
        view.backgroundColor = .red
        
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
    
    func configureTableView(){
        
        profileTableView = UITableView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height))
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(profileTableView)
        
    }
    
    //MARK: -Handlers
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
        
        showAlertWithCancel(title: "Logging Out", message: "Are you sure?", buttonText: "Log Out") {
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation,animated: true)
            }
            catch{
                self.showAlert(title: "Error", message: "Failed to Log out")
                print("Failed to Logout")
            }
        }
        
    }
    
}
