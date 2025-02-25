//
//  KitchenSeeMoreViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 09/02/25.
//

import UIKit

class KitchenSeeMoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate {

    @IBOutlet weak var AllKitchens: UICollectionView!
    
    
    var isSearching: Bool = false

    
    var searchBar: UISearchBar!
    var filterScrollView: UIScrollView!
    var filterStackView: UIStackView!
    var itemCountLabel: UILabel!
    
    var allKitchens = KitchenDataController.kitchens
    var filteredKitchens: [Kitchen] = []
    var isFilteringOnline = false
    var selectedFilters: [String: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .white
        self.title = "Nearest Kitchens"
        
        configureSearchBar()
        configureFilterStackView()
        configureItemCountLabel()
        
        AllKitchens.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(AllKitchens)

        NSLayoutConstraint.activate([
            AllKitchens.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 10),
            AllKitchens.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            AllKitchens.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            AllKitchens.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        let chefSpecialMenuNib = UINib(nibName: "KitchenViewCell", bundle: nil)
        AllKitchens.register(chefSpecialMenuNib, forCellWithReuseIdentifier: "KitchenViewCell")
        
        // Setting Layout
        AllKitchens.setCollectionViewLayout(generateLayout(), animated: true)
        AllKitchens.dataSource = self
        AllKitchens.delegate = self
        
        
        filteredKitchens = allKitchens
        updateItemCount()
        AllKitchens.reloadData()
    }


    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal // Removes background lines
        searchBar.backgroundImage = UIImage() // Removes background shadow
        searchBar.showsCancelButton = false // Hide cancel button initially
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    
    func configureFilterStackView() {
        filterScrollView = UIScrollView()
        filterScrollView.showsHorizontalScrollIndicator = false
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        filterStackView.spacing = 15.0
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let filterTitles = ["Sort", "Nearest", "Ratings 4.0+", "Pure Veg", "Online"]
        
        for title in filterTitles {
            let button = createFilterButton(title: title)
            filterStackView.addArrangedSubview(button)
        }
        
        filterScrollView.addSubview(filterStackView)
        view.addSubview(filterScrollView)
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor),
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
        ])
    }
    
// MARK: - Configure Item Count Label
func configureItemCountLabel() {
    itemCountLabel = UILabel()
    itemCountLabel.textAlignment = .center
    itemCountLabel.textColor = .gray
    itemCountLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    itemCountLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(itemCountLabel)
    
    NSLayoutConstraint.activate([
        itemCountLabel.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 15),
        itemCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        itemCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        itemCountLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
}


    func createFilterButton(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.accent.cgColor
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            button.tag = filterStackView.arrangedSubviews.count
            updateFilterButtonAppearance(button, isSelected: false)

            return button
        }

    
    @objc func filterButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), title != "Sort" else { return }
        
        // Toggle filter state
        selectedFilters[title] = !(selectedFilters[title] ?? false)

        // Apply filters based on active selections
        applyFilters()
        
        // Update button appearance
        updateFilterButtonAppearance(sender, isSelected: selectedFilters[title] ?? false)
        
        // Reload data
        updateItemCount()
        AllKitchens.reloadData()
    }
    
    func applyFilters() {
        let searchText = searchBar.text?.lowercased() ?? ""
        
        // Apply search first
        if searchText.isEmpty {
            filteredKitchens = allKitchens
        } else {
            filteredKitchens = allKitchens.filter { $0.name.lowercased().contains(searchText) }
        }

        // Apply additional filters ONLY on the already searched list
        if selectedFilters["Online"] == true {
            filteredKitchens = filteredKitchens.filter { $0.isOnline }
        }

        if selectedFilters["Nearest"] == true {
            filteredKitchens.sort { $0.distance < $1.distance }
        }

        if selectedFilters["Ratings 4.0+"] == true {
            filteredKitchens = filteredKitchens.filter { $0.rating >= 4.0 }
            filteredKitchens.sort { $0.rating > $1.rating }
        }

        if selectedFilters["Pure Veg"] == true {
            filteredKitchens = filteredKitchens.filter { $0.isPureVeg }
        }

        // Reload UI
        updateItemCount()
        AllKitchens.reloadData()
    }



    
    func updateFilterButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor.accent
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters() // Instead of filtering separately, just apply filters
    }


    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        applyFilters() // Reset filters while keeping logic intact
    }


    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true) // Show Cancel button when clicked
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredKitchens.count
    }



// MARK: - Update Item Count Label
    func updateItemCount() {
            let count = filteredKitchens.count
            DispatchQueue.main.async {
                self.itemCountLabel.text = "\(count) Kitchens Available For You"
            }
        }


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenViewCell", for: indexPath) as! KitchenSeeMoreCollectionViewCell
        let kitchen = filteredKitchens[indexPath.row]
        cell.updateSpecialDishDetails(with: kitchen)
        return cell
        }
    


    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16.0, bottom: 8.0, trailing: 16.0)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

}
