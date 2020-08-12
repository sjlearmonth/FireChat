//
//  ChatController.swift
//  FireChat
//
//  Created by Stephen Learmonth on 12/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import UIKit

class ChatController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        print("DEBUG: User in chat controller is \(user.username)")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
    }
    
}
