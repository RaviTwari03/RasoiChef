//
//  LandingPageChefSpecialityViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 23/01/25.
//

import UIKit

class LandingPageChefSpecialitySeeMoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate , ChefSpecialMenuSeeMoreDetailsCellDelegate {
    
    @IBOutlet var ChefsSpecialDishes: UICollectionView!

        var searchBar: UISearchBar!
        var filterScrollView: UIScrollView!
        var filterStackView: UIStackView!
        var itemCountLabel: UILabel!
        var filteredChefSpecialDishes: [ChefSpecialtyDish] = []
        var activeFilters: Set<String> = []
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.largeTitleDisplayMode = .never
            self.view.backgroundColor = .white
            self.title = "Chef's Speciality"
            
            configureSearchBar()
            configureFilterStackView()
            configureItemCountLabel()
            
            ChefsSpecialDishes.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(ChefsSpecialDishes)

            NSLayoutConstraint.activate([
                ChefsSpecialDishes.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 10),
                ChefsSpecialDishes.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                ChefsSpecialDishes.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                ChefsSpecialDishes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
            
            let chefSpecialMenuNib = UINib(nibName: "ChefSpecialMenuSeeMore", bundle: nil)
            ChefsSpecialDishes.register(chefSpecialMenuNib, forCellWithReuseIdentifier: "ChefSpecialMenuSeeMore")
            
            // Setting Layout
            ChefsSpecialDishes.setCollectionViewLayout(generateLayout(), animated: true)
            ChefsSpecialDishes.dataSource = self
            ChefsSpecialDishes.delegate = self
            
            filteredChefSpecialDishes = KitchenDataController.globalChefSpecial
            updateItemCount()

        }

    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false  // Initially hidden
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
        
        let filterTitles = ["Nearest", "Ratings 4.0+", "Pure Veg", "Cost Low to High"]
        
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


    
    func updateFilterButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor.accent
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
    }

        
    @objc func filterButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if activeFilters.contains(title) {
            activeFilters.remove(title) // Remove filter if already applied
            updateFilterButtonAppearance(sender, isSelected: false) // Update color
        } else {
            activeFilters.insert(title) // Apply new filter
            updateFilterButtonAppearance(sender, isSelected: true) // Update color
        }

        applyFilters()
    }



    
    
    func applyFilters() {
        filteredChefSpecialDishes = KitchenDataController.globalChefSpecial // Start with full list

        // Apply search first if there's text
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredChefSpecialDishes = filteredChefSpecialDishes.filter { dish in
                return dish.name.lowercased().contains(searchText.lowercased())
            }
        }

        // Apply filters one by one
        if activeFilters.contains("Nearest") {
            filteredChefSpecialDishes.sort { $0.distance < $1.distance }
        }
        if activeFilters.contains("Ratings 4.0+") {
            filteredChefSpecialDishes = filteredChefSpecialDishes.filter { $0.rating >= 4.0 }
        }
        if activeFilters.contains("Pure Veg") {
            filteredChefSpecialDishes = filteredChefSpecialDishes.filter { $0.mealCategory.contains(.veg) }
        }
        if activeFilters.contains("Cost: Low to High") {
            filteredChefSpecialDishes.sort { $0.price < $1.price }
        }

        updateItemCount() 
        ChefsSpecialDishes.reloadData()
    }



        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredChefSpecialDishes.count
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredChefSpecialDishes = KitchenDataController.globalChefSpecial
        } else {
            filteredChefSpecialDishes = KitchenDataController.globalChefSpecial.filter { dish in
                return dish.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        applyFilters()
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true) // Hide cancel button
        searchBar.resignFirstResponder() // Hide keyboard
        
        filteredChefSpecialDishes = KitchenDataController.globalChefSpecial // Reset to all dishes
        updateItemCount()
        ChefsSpecialDishes.reloadData()
    }


    
    
    
    // MARK: - Update Item Count Label
    func updateItemCount() {
        let count = filteredChefSpecialDishes.count
        itemCountLabel.text = "\(count) Dishes Available for You"
    }


    
    
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialMenuSeeMore", for: indexPath) as! ChefSeeMoreCollectionViewCell
        
        let dish = filteredChefSpecialDishes[indexPath.row] // Now using filtered list
        cell.updateSpecialDishDetails(with: dish) // Corrected function call
        cell.delegate = self

        // Cell Styling
        cell.layer.cornerRadius = 15.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false

        return cell
    }


        
    
    
        func generateLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(345))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16.0, bottom: 8.0, trailing: 16.0)
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            return UICollectionViewCompositionalLayout(section: section)
        }
    
    
    func ChefSpecialaddButtonTapped(in cell: ChefSeeMoreCollectionViewCell) {
        guard let indexPath = ChefsSpecialDishes.indexPath(for: cell) else { return }
        
        // Fetch the Chef Specialty Dish from the data controller
        let selectedChefSpecialtyDish = filteredChefSpecialDishes[indexPath.row]
        print("Add button tapped for Chef Specialty Dish: \(selectedChefSpecialtyDish.name)")
        
        // Instantiate the detail view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            // Pass the selected Chef Specialty Dish to the detailVC
            detailVC.selectedChefSpecialtyDish = selectedChefSpecialtyDish
            
            // Set the modal presentation style
            detailVC.modalPresentationStyle = .pageSheet
            
            // Customize the presentation style for iPad/large screens
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            // Present the modal view controller
            present(detailVC, animated: true, completion: nil)
        } else {
            print("Error: Could not instantiate AddItemModallyViewController")
        }
    }
    
}
