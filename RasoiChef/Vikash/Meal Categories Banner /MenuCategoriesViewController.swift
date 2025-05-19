//
//  MenuCategoriesViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit


protocol MealCategoriesCollectionViewCellDelegate: AnyObject {
    func MealcategoriesButtonTapped(in cell: MenuCategoriesCollectionViewCell)
}

class MenuCategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate,MealCategoriesCollectionViewCellDelegate {
    
    var filteredMenuItems: [MenuItem] = [] // Stores filtered items for search
    var isSearching = false // Flag to check if search is active
    private let refreshControl = UIRefreshControl()
    
    // Custom loading view
    private let loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        if let image = UIImage(systemName: "fork.knife")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)) {
            imageView.image = image
        }
        return imageView
    }()
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading meal categories..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private var symbolRotationTimer: Timer?
    private let symbols = [
        ("fork.knife", "Loading meal categories..."),
        ("clock.fill", "Finding perfect meals..."),
        ("leaf.fill", "Fresh options for you..."),
        ("heart.fill", "Curated with care..."),
        ("star.fill", "Special selections...")
    ]
    private var currentSymbolIndex = 0

    var menuItems: [MenuItem] = []

    var mealTiming : MealTiming = .breakfast
    
    @IBOutlet weak var MealCategories: UICollectionView!
    
    var searchBar: UISearchBar!
    var filterScrollView: UIScrollView!
    var filterStackView: UIStackView!
    var itemCountLabel: UILabel!
    
    var activeFilters: Set<String> = []
    
    
    var MenuCategories: [MenuItem] = []
 
           func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               return filteredMenuItems.count
           }
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        
        // Setup loading view
        setupLoadingView()
        
        updateTitleBasedOnMealTiming()
        
        // Register the custom cell XIB
        let menuCategoriesNib = UINib(nibName: "MealCategories", bundle: nil)
        MealCategories.register(menuCategoriesNib, forCellWithReuseIdentifier: "MealCategories")
        
        // Set up collection view layout
        MealCategories.setCollectionViewLayout(generateLayout(), animated: true)
        
        // Set the delegate and data source
        MealCategories.delegate = self
        MealCategories.dataSource = self
        
        // Add refresh control - moved after collection view setup
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        MealCategories.refreshControl = refreshControl
        
        // Reload data
        MealCategories.reloadData()
        
        configureSearchBar()
        configureFilterStackView()
        configureItemCountLabel()
        
        MealCategories.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(MealCategories)

        NSLayoutConstraint.activate([
            MealCategories.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 10),
            MealCategories.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MealCategories.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MealCategories.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        updateItemCount()
        updateMenuItems()
        
    }
    
    
    func updateMenuItems() {
        switch mealTiming {
        case .breakfast:
            menuItems = KitchenDataController.GlobalbreakfastMenuItems
        case .lunch:
            menuItems = KitchenDataController.GloballunchMenuItems
        case .snacks:
            menuItems = KitchenDataController.GlobalsnacksMenuItems
        case .dinner:
            menuItems = KitchenDataController.GlobaldinnerMenuItems
        }
        
        applyFilters()
    }
    
    func applyFilters() {
        var itemsToFilter: [MenuItem]

        if isSearching {
            // Work on the search results instead of the full menu
            itemsToFilter = menuItems.filter { $0.name.localizedCaseInsensitiveContains(searchBar.text ?? "") }
        } else {
            itemsToFilter = menuItems
        }

        // Apply filters
        if activeFilters.contains("Nearest") {
            itemsToFilter.sort { $0.distance < $1.distance }
        }

        if activeFilters.contains("Ratings 4.0+") {
            itemsToFilter = itemsToFilter.filter { $0.rating >= 4.0 }
            itemsToFilter.sort { $0.rating > $1.rating }
        }

        if activeFilters.contains("Pure Veg") {
            itemsToFilter = itemsToFilter.filter { $0.mealCategory.contains(.veg) }
        }

        if activeFilters.contains("Cost Low to High") {
            itemsToFilter.sort { $0.price < $1.price }
        }

        // Update filtered list
        filteredMenuItems = itemsToFilter

        MealCategories.reloadData()
        updateItemCount()
    }

    
    
    func updateTitleBasedOnMealTiming() {
        switch mealTiming {
        case .breakfast: self.title = "Breakfast"
        case .lunch: self.title = "Lunch"
        case .snacks: self.title = "Snacks"
        case .dinner: self.title = "Dinner"
        }
    }
    
    
    
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal // Removes background lines
        searchBar.backgroundImage = UIImage() // Removes background shadow
        searchBar.showsCancelButton = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""  // Clear search text
        searchBar.resignFirstResponder() // Dismiss keyboard
        isSearching = false
        filteredMenuItems = menuItems // Reset to full menu
        searchBar.setShowsCancelButton(false, animated: true) // Hide cancel button with animation

        MealCategories.reloadData() // Reload full data
        updateItemCount() // Update count after reset
    }


    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true) // Show cancel button with animation
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
            button.layer.cornerRadius = 12
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            return button
        }

    
    @objc func filterButtonTapped(_ sender: UIButton) {
            guard let title = sender.title(for: .normal) else { return }
            
            if activeFilters.contains(title) {
                activeFilters.remove(title)
                sender.backgroundColor = .white
                sender.setTitleColor(.black, for: .normal)
            } else {
                activeFilters.insert(title)
                sender.backgroundColor = .accent
                sender.setTitleColor(.white, for: .normal)
            }
            
            applyFilters()
        }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        searchBar.setShowsCancelButton(!searchText.isEmpty, animated: true) // Hide if empty
        applyFilters() // Apply filters after searching
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }


    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    // MARK: - Update Item Count Label
    func updateItemCount() {
        itemCountLabel.text = "\(filteredMenuItems.count) Dishes Available For You"
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCategories", for: indexPath) as! MenuCategoriesCollectionViewCell
        cell.layer.cornerRadius = 15.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.mealTiming = mealTiming

        // Ensure using filtered items
        let menuItem = filteredMenuItems[indexPath.row]
            cell.updateMealDetails(with: menuItem)

        cell.delegate = self
        return cell
    }

    
    
    
    func MealcategoriesButtonTapped(in cell: MenuCategoriesCollectionViewCell) {
        guard let indexPath = MealCategories.indexPath(for: cell) else { return }

        // Fetch the correct item from filteredMenuItems
        let selectedItem = filteredMenuItems[indexPath.row]

        print("Add button tapped for meal: \(selectedItem.name)")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            detailVC.selectedItem = selectedItem

            // Present as a bottom sheet
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()] // Medium-sized sheet
                sheet.prefersGrabberVisible = true    // Show grabber handle
            }

            detailVC.modalPresentationStyle = .pageSheet
            present(detailVC, animated: true, completion: nil)
        } else {
            print("Error: Could not instantiate AddItemModallyViewController")
        }
    }


    
    
     func generateLayout() -> UICollectionViewLayout {
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
         group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16.0, bottom: 8.0, trailing: 16.0)
         group.interItemSpacing = .fixed(10)

         let section = NSCollectionLayoutSection(group: group)
         return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.addSubview(symbolImageView)
        loadingView.addSubview(quoteLabel)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 200),
            loadingView.heightAnchor.constraint(equalToConstant: 100),
            
            symbolImageView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            symbolImageView.topAnchor.constraint(equalTo: loadingView.topAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 40),
            symbolImageView.heightAnchor.constraint(equalToConstant: 40),
            
            quoteLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 10),
            quoteLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 10),
            quoteLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -10),
            quoteLabel.bottomAnchor.constraint(lessThanOrEqualTo: loadingView.bottomAnchor)
        ])
        
        loadingView.isHidden = true
    }
    
    private func showLoadingIndicator() {
        loadingView.isHidden = false
        MealCategories.isHidden = true
        startSymbolRotation()
    }
    
    private func hideLoadingIndicator() {
        loadingView.isHidden = true
        MealCategories.isHidden = false
        stopSymbolRotation()
    }
    
    private func startSymbolRotation() {
        // Initial rotation animation
        startRotationAnimation()
        
        symbolRotationTimer?.invalidate()
        symbolRotationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Update symbol and quote with fade
            UIView.transition(with: self.symbolImageView,
                            duration: 0.5,
                            options: [.transitionCrossDissolve, .allowUserInteraction],
                            animations: {
                self.currentSymbolIndex = (self.currentSymbolIndex + 1) % self.symbols.count
                let (symbolName, quote) = self.symbols[self.currentSymbolIndex]
                if let image = UIImage(systemName: symbolName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)) {
                    self.symbolImageView.image = image
                }
                
                UIView.transition(with: self.quoteLabel,
                                duration: 0.5,
                                options: [.transitionCrossDissolve, .allowUserInteraction],
                                animations: {
                    self.quoteLabel.text = quote
                }, completion: nil)
            }, completion: { _ in
                // Restart rotation animation after symbol change
                self.startRotationAnimation()
            })
        }
        symbolRotationTimer?.fire()
    }
    
    private func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 2.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity
        symbolImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopSymbolRotation() {
        symbolRotationTimer?.invalidate()
        symbolRotationTimer = nil
        symbolImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    @objc private func refreshData() {
        print("\n🔄 Refreshing data...")
        showLoadingIndicator()
        Task {
            do {
                try await KitchenDataController.loadData()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Check if data was loaded successfully
                    if !KitchenDataController.kitchens.isEmpty || !KitchenDataController.menuItems.isEmpty {
                        self.MealCategories.reloadData()
                        self.updateItemCount()
                    }
                    
                    self.refreshControl.endRefreshing()
                    self.hideLoadingIndicator()
                }
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Show an error alert to the user
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to update content. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    
                    self.refreshControl.endRefreshing()
                    self.hideLoadingIndicator()
                }
            }
        }
    }
}

