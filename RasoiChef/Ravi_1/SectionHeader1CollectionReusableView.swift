//
//  SectionHeader1CollectionReusableView.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class SectionHeader1CollectionReusableView: UICollectionReusableView {
    var headerLabel = UILabel()
    var actionButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerLabel.textColor = .black
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("See All", for: .normal)
        actionButton.setTitleColor(.systemBlue, for: .normal)
        
        addSubview(headerLabel)
        addSubview(actionButton)
        
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
