//
//  NewConversationViewController.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit

class NewConversationViewController: UIViewController {

    private var users = [[String:String]]()
    private var results = [[String:String]]()
    
    var spinnerT = UIActivityIndicatorView(style: .large)
    
    private var hasFetched = false
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No search results"
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        configureNavBar()
        configureTableView()
        configureSpinner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.frame.width / 4, y: (view.frame.height-200) / 2, width: view.frame.width / 2, height: 200)
    }
    
    func configureNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dissmissScreen))
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        tableView.delegate = self
        tableView.dataSource = self
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
}

extension NewConversationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //start conversation
    }
    
}

extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        //add spinner here
        startSpinning()
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String){
            //check if array has firebase results
        if hasFetched{
            //if does then filter
            filterUsers(with: query)
        }
        else{
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result{
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users \(error)")
                }
           
            }
        }
    }
    
    func filterUsers(with term : String){
        guard hasFetched else{
            return
        }
        //dismiss spinner here
        stopSpinning()
        
        let results : [[String:String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        
        self.results = results
        updateUI()
    }
    
    func updateUI(){
        if results.isEmpty{
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else{
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
