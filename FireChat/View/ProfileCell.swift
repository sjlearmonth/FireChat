//
//  ProfileCell.swift
//  FireChat
//
//  Created by Stephen Learmonth on 18/08/2020.
//  Copyright © 2020 Stephen Learmonth. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: ProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.centerY(inView: view)
        view.backgroundColor = .systemPurple
        view.setDimensions(height: 40, width: 40)
        view.layer.cornerRadius = 40 / 2
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iiv = UIImageView()
        iiv.contentMode = .scaleAspectFill
        iiv.clipsToBounds = true
        iiv.setDimensions(height: 28, width: 28)
        iiv.tintColor = .white
        return iiv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.spacing = 8
        stackView.axis = .horizontal
        
        addSubview(stackView)
        stackView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        iconImageView.image = UIImage(systemName: viewModel.iconImageName)
        titleLabel.text = viewModel.description
    }
}
