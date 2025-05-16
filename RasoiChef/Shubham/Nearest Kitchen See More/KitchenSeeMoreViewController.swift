//
//  KitchenSeeMoreViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 09/02/25.
//

import UIKit

class KitchenSeeMoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate {

    @IBOutlet weak var AllKitchens: UICollectionView!
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
        if let image = UIImage(systemName: "house.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)) {
            imageView.image = image
        }
        return imageView
    }()
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Finding nearby kitchens..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private var symbolRotationTimer: Timer?
    private let symbols = [
        ("house.fill", "Finding nearby kitchens..."),
        ("location.fill", "Checking locations..."),
        ("star.fill", "Top rated kitchens..."),
        ("heart.fill", "Local favorites..."),
        ("fork.knife", "Great food awaits...")
    ]
    private var currentSymbolIndex = 0

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
        
        // Setup loading view
        setupLoadingView()
        
        // Add refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        AllKitchens.refreshControl = refreshControl
        
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
        
        let filterTitles = ["Nearest", "Ratings 4.0+", "Pure Veg", "Online"]
        
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
        guard let title = sender.title(for: .normal) else { return }
        
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                let selectedKitchen = filteredKitchens[indexPath.item]
                if !selectedKitchen.isOnline {
                    return // Prevent navigation if kitchen is offline
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let kitchenDetailVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                    kitchenDetailVC.kitchenData = selectedKitchen
                    self.navigationController?.pushViewController(kitchenDetailVC, animated: true)
                }
            }
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
        AllKitchens.isHidden = true
        startSymbolRotation()
    }
    
    private func hideLoadingIndicator() {
        loadingView.isHidden = true
        AllKitchens.isHidden = false
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
        print("\n🔄 Refreshing kitchens data...")
        showLoadingIndicator()
        Task {
            do {
                try await KitchenDataController.loadData()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Check if data was loaded successfully
                    if !KitchenDataController.kitchens.isEmpty {
                        self.allKitchens = KitchenDataController.kitchens
                        self.filteredKitchens = self.allKitchens
                        self.AllKitchens.reloadData()
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
