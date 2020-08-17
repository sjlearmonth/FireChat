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
    weak var delegate: NewMessageControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchChatPartners()
    }
    
    // MARK: - Helpers
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchChatPartners() {
        Service.fetchChatPartners {chatPartners in
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
}

// MARK: - UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatPartners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = chatPartners[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: chatPartners[indexPath.row])
    }
}
