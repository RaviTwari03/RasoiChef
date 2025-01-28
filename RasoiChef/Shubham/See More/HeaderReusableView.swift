//
//  HeaderReusableView.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 28/01/25.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    let searchBar = UISearchBar()
        let filterStackView = UIStackView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configureSearchBar()
            configureFilterStackView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            configureSearchBar()
            configureFilterStackView()
        }
        
        func configureSearchBar() {
            searchBar.placeholder = "Search"
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            addSubview(searchBar)
            
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                searchBar.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        func configureFilterStackView() {
            let sortButton = createFilterButton(title: "Sort")
            let nearestButton = createFilterButton(title: "Nearest")
            let ratingsButton = createFilterButton(title: "Ratings 4.0+")
            let pureVegButton = createFilterButton(title: "Pure Veg")
            
            filterStackView.axis = .horizontal
            filterStackView.distribution = .fillEqually
            filterStackView.spacing = 8
            filterStackView.translatesAutoresizingMaskIntoConstraints = false
            filterStackView.addArrangedSubview(sortButton)
            filterStackView.addArrangedSubview(nearestButton)
            filterStackView.addArrangedSubview(ratingsButton)
            filterStackView.addArrangedSubview(pureVegButton)
            
            addSubview(filterStackView)
            
            NSLayoutConstraint.activate([
                filterStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
                filterStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                filterStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                filterStackView.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        func createFilterButton(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemOrange
            button.layer.cornerRadius = 8
            return button
        }
    }

