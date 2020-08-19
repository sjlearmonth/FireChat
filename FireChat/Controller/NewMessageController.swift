//
//  NewMessageController.swift
//  FireChat
//
//  Created by Stephen Learmonth on 10/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith chatPartner: User)
}

class NewMessageController: UITableViewController {
    
    // MARK - Properties
    
    private var chatPartners = [User]()
    private var filteredChatPartners = [User]()
    weak var delegate: NewMessageControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive == true && searchController.searchBar.text?.isEmpty == false
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchChatPartners()
    }
    
    // MARK: - Helpers
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchChatPartners() {
        showLoader(true)
        Service.fetchChatPartners {chatPartners in
            self.showLoader(false)
            self.chatPartners = chatPartners
            self.tableView.reloadData()
            print("DEBUG: Users in new message controller \(chatPartners)")
        }
    }
    
    func configureUI() {
        
        configureNavigationBar(withTitle: "New Message(s)", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a chat partner"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
}

// MARK: - UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredChatPartners.count : chatPartners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredChatPartners[indexPath.row] : chatPartners[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatPartner = inSearchMode ? filteredChatPartners[indexPath.row] : chatPartners[indexPath.row]
        delegate?.controller(self, wantsToStartChatWith: chatPartner)
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredChatPartners = chatPartners.filter({ chatPartner -> Bool in
            return chatPartner.username.contains(searchText) ||
                   chatPartner.fullname.contains(searchText)
        })
        self.tableView.reloadData()
    }
}
