//
//  SearchDishesViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 04/03/25.
//

import UIKit

class SearchDishesViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
    private var collectionView: UICollectionView!
    private var searchResults: [SearchResult] = []
    private var allItems: [SearchResult] = []

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        loadAllItems()
        
        // Ensure search bar is visible immediately
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Ensure search bar is visible and active
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure search bar is visible and active
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.isActive = false
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Search Dishes"
        
        // Setup collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // Calculate item size based on screen width
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5) // 1.5 aspect ratio
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for dishes..."
        searchController.searchBar.delegate = self
        
        // Configure search bar appearance
        searchController.searchBar.searchTextField.backgroundColor = .systemGray6
        searchController.searchBar.tintColor = .systemGreen
        
        // Set search bar in navigation item
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Ensure search bar is visible
        definesPresentationContext = true
        
        // Make search bar active immediately
        searchController.isActive = true
    }
    
    // MARK: - Data Loading
    private func loadAllItems() {
        // Combine menu items and chef specials into search results
        var results: [SearchResult] = []
        
        // Add menu items
        for item in KitchenDataController.menuItems {
            results.append(SearchResult(
                id: item.itemID,
                name: item.name,
                description: item.description,
                price: item.price,
                imageURL: item.imageURL,
                type: .menuItem,
                kitchenName: item.kitchenName,
                rating: item.rating
            ))
        }
        
        // Add chef specials
        for dish in KitchenDataController.globalChefSpecial {
            results.append(SearchResult(
                id: dish.dishID,
                name: dish.name,
                description: dish.description,
                price: dish.price,
                imageURL: dish.imageURL,
                type: .chefSpecial,
                kitchenName: dish.kitchenName,
                rating: dish.rating
            ))
        }
        
        allItems = results
        searchResults = results
        collectionView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension SearchDishesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
            searchResults = allItems
            collectionView.reloadData()
            return
        }
        
        searchResults = allItems.filter { item in
            item.name.lowercased().contains(searchText) ||
            item.description.lowercased().contains(searchText) ||
            item.kitchenName.lowercased().contains(searchText)
        }
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchDishesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let item = searchResults[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchDishesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResults[indexPath.item]
        
        // Navigate to appropriate detail view based on item type
        switch item.type {
        case .menuItem:
            // Navigate to menu item detail
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
                // Find the menu item
                if let menuItem = KitchenDataController.menuItems.first(where: { $0.itemID == item.id }) {
                    detailVC.selectedItem = menuItem
                    detailVC.modalPresentationStyle = .pageSheet
                    if let sheet = detailVC.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                    }
                    present(detailVC, animated: true)
                }
            }
        case .chefSpecial:
            // Navigate to chef special detail
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
                // Find the chef special
                if let chefSpecial = KitchenDataController.globalChefSpecial.first(where: { $0.dishID == item.id }) {
                    detailVC.selectedChefSpecialtyDish = chefSpecial
                    detailVC.modalPresentationStyle = .pageSheet
                    if let sheet = detailVC.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                    }
                    present(detailVC, animated: true)
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchDishesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = allItems
        collectionView.reloadData()
    }
}

// MARK: - SearchResult Model
struct SearchResult {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let type: ItemType
    let kitchenName: String
    let rating: Float
    
    enum ItemType {
        case menuItem
        case chefSpecial
    }
}

// MARK: - SearchResultCell
class SearchResultCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let kitchenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(kitchenLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            kitchenLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            kitchenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            kitchenLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: kitchenLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            ratingLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with item: SearchResult) {
        nameLabel.text = item.name
        kitchenLabel.text = item.kitchenName
        priceLabel.text = "₹\(String(format: "%.2f", item.price))"
        ratingLabel.text = "★ \(String(format: "%.1f", item.rating))"
        
        // Load image
        if let url = URL(string: item.imageURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        kitchenLabel.text = nil
        priceLabel.text = nil
        ratingLabel.text = nil
    }
}



