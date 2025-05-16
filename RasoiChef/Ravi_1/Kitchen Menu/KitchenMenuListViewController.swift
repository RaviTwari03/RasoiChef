//
//  KitchenMenuListViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class KitchenMenuListViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,MenuDetailsCellDelegate, KitchenMenuDetailsCellDelegate {
    
    var selectedDay: WeekDay = .monday // Default to Monday (Change as needed)
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
        label.text = "Loading today's menu..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private var symbolRotationTimer: Timer?
    private let symbols = [
        ("fork.knife", "Loading today's menu..."),
        ("calendar", "Checking daily specials..."),
        ("leaf.fill", "Fresh menu coming up..."),
        ("heart.fill", "Curated with love..."),
        ("star.fill", "Special dishes for you...")
    ]
    private var currentSymbolIndex = 0

    func KitchenMenuListaddButtonTapped(in cell: KitchenMenuCollectionViewCell) {
        guard let indexPath = KitchenMenuList.indexPath(for: cell) else { return }
        let filteredMenu = KitchenDataController.filteredMenuItems.filter { $0.availableDays == selectedDay }
        guard indexPath.row < filteredMenu.count else { return }
        
        let selectedItem = filteredMenu[indexPath.row]
        print("Add button tapped for meal: \(selectedItem.name)")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            detailVC.selectedItem = selectedItem
            
            detailVC.modalPresentationStyle = .pageSheet
            
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }

            present(detailVC, animated: true, completion: nil)
        } else {
            print("Error: Could not instantiate AddItemModallyViewController")
        }
    }
    
    @IBOutlet var KitchenMenuList: UICollectionView!
    
    var menuItems: [MenuItem] = []
    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Menu"
        
        // Setup loading view
        setupLoadingView()
        
        // Print initial menu items state
        print("\n=== Menu Items State at ViewDidLoad ===")
        print("Total filtered menu items: \(KitchenDataController.filteredMenuItems.count)")
        let filteredMenu = KitchenDataController.filteredMenuItems.filter { $0.availableDays == selectedDay }
        print("Filtered menu items for \(selectedDay): \(filteredMenu.count)")
        
        // Debug: Print all menu items and their available days
        print("\nFiltered Menu Items:")
        for (index, item) in KitchenDataController.filteredMenuItems.enumerated() {
            print("\nItem \(index + 1):")
            print("- Name: \(item.name)")
            print("- Available Day: \(item.availableDays.rawValue)")
            print("- Meal Type: \(String(describing: item.availableMealTypes))")
            print("- Kitchen: \(item.kitchenName)")
        }
        
        // Load data if needed
        if KitchenDataController.filteredMenuItems.isEmpty {
            print("No menu items found, loading data...")
            Task {
                do {
                    try await KitchenDataController.loadData()
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        print("\n=== Menu Items State after Loading ===")
                        print("Total filtered menu items: \(KitchenDataController.filteredMenuItems.count)")
                        let filteredMenu = KitchenDataController.filteredMenuItems.filter { $0.availableDays == self.selectedDay }
                        print("Filtered menu items for \(self.selectedDay): \(filteredMenu.count)")
                        
                        // Debug: Print all menu items after loading
                        print("\nFiltered Menu Items after loading:")
                        for (index, item) in KitchenDataController.filteredMenuItems.enumerated() {
                            print("\nItem \(index + 1):")
                            print("- Name: \(item.name)")
                            print("- Available Day: \(item.availableDays.rawValue)")
                            print("- Meal Type: \(String(describing: item.availableMealTypes))")
                            print("- Kitchen: \(item.kitchenName)")
                        }
                        
                        self.KitchenMenuList.reloadData()
                    }
                } catch {
                    print("Error loading data: \(error)")
                }
            }
        }
        
        // Registering Nibs for Cells
        let kitchenMenuCalenderNib = UINib(nibName: "KitchenMenuCalender", bundle: nil)
        let kitchenMenuNib = UINib(nibName: "KitchenMenu", bundle: nil)
        
        KitchenMenuList.register(kitchenMenuCalenderNib, forCellWithReuseIdentifier: "KitchenMenuCalender")
        KitchenMenuList.register(kitchenMenuNib, forCellWithReuseIdentifier: "KitchenMenu")
        
        // Setting Layout
        KitchenMenuList.setCollectionViewLayout(generateLayout(), animated: true)
        KitchenMenuList.dataSource = self
        KitchenMenuList.delegate = self
        
        // Add refresh control - moved after collection view setup
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        KitchenMenuList.refreshControl = refreshControl
        
        DispatchQueue.main.async {
            let todayIndexPath = IndexPath(item: 0, section: 0)
            self.KitchenMenuList.selectItem(at: todayIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            if let cell = self.KitchenMenuList.cellForItem(at: todayIndexPath) as? KitchenMenuCalenderCollectionViewCell {
                cell.isSelected = true  // Ensure the cell appears selected
            }
        }
    }
    
  

    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7 // Calendar days
        case 1:
            let filteredMenu = KitchenDataController.filteredMenuItems.filter { $0.availableDays == selectedDay }
            print("\n=== Number of Items Debug ===")
            print("Section: \(section)")
            print("Selected Day: \(selectedDay)")
            print("Total Menu Items: \(KitchenDataController.filteredMenuItems.count)")
            print("Filtered Menu Items: \(filteredMenu.count)")
            if let firstItem = KitchenDataController.filteredMenuItems.first {
                print("First Item Available Day: \(firstItem.availableDays)")
            }
            return filteredMenu.count
        default:
            return 0
        }
    }

    
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenMenuCalender", for: indexPath) as! KitchenMenuCalenderCollectionViewCell
            cell.updateMenuListDate(for: indexPath)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenMenu", for: indexPath) as! KitchenMenuCollectionViewCell
            let filteredMenu = KitchenDataController.filteredMenuItems.filter { $0.availableDays == selectedDay }
            
            if indexPath.row < filteredMenu.count {
                let menuItem = filteredMenu[indexPath.row]
                print("Configuring cell at index \(indexPath.row) with menu item: \(menuItem.name)")
                cell.updateMealDetails(with: menuItem, at: indexPath)
            } else {
                print("Index \(indexPath.row) is out of bounds for filtered menu count: \(filteredMenu.count)")
            }
            
            cell.delegate = self
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }

    
    // MARK: - Compositional Layout
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            switch sectionIndex {
            case 0:
                section = self.generateMenuCalenderSectionLayout()
            case 1:
                section = self.generateMenuListSectionLayout()
                
            default:
                return nil
            }
            
            return section
        }
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { // If Calendar Section is clicked
            let selectedCell = collectionView.cellForItem(at: indexPath) as? KitchenMenuCalenderCollectionViewCell
            selectedDay = WeekDay.allCases[indexPath.row] // Assuming WeekDay enum follows correct order
            
            // Reload the menu items based on selected date
            KitchenMenuList.reloadSections(IndexSet(integer: 1))
        }
    }

    // Calendar Section Layout
    func generateMenuCalenderSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading:5.0, bottom: 8.0, trailing: 0.0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 15.0, leading: 15.0, bottom: 10.0, trailing: 10.0)

        return section
    }
    // Menu List Section Layout
    func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(235))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5.0, bottom: 0.0, trailing: 5.0)
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 0, trailing: 8.0)
        section.interGroupSpacing = 0

        return section
    }    
    //    MARK: - For ADD button in the menu items cell
        func MenuListaddButtonTapped(in cell: MenuDetailsCollectionViewCell) {
            guard let indexPath = KitchenMenuList.indexPath(for: cell) else { return }
            let selectedItem = KitchenDataController.menuItems[indexPath.row]
            print("Add button tapped for meal: \(selectedItem.name)")
    
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
                detailVC.selectedItem = selectedItem
                present(detailVC, animated: true, completion: nil)
            } else {
                print("Error: Could not instantiate AddItemModallyViewController")
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
        KitchenMenuList.isHidden = true
        startSymbolRotation()
    }
    
    private func hideLoadingIndicator() {
        loadingView.isHidden = true
        KitchenMenuList.isHidden = false
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
                        self.KitchenMenuList.reloadData()
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
