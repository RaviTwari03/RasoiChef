//
//  LandingPageViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit
import UserNotifications

class LandingPageViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UISearchResultsUpdating,LandingPageChefSpecialDetailsCellDelegate {

    @IBOutlet var LandingPage: UICollectionView!
    @IBOutlet weak var kitchenCollectionView: UICollectionView?
    
    // Add UNUserNotificationCenter property
    private let notificationCenter = UNUserNotificationCenter.current()
    
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
        if let image = UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)) {
            imageView.image = image
        }
        return imageView
    }()
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Made with love\nServed with care"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private var symbolRotationTimer: Timer?
    private let symbols = [
        ("heart.fill", "Made with love\nServed with care"),
        ("sparkles", "Creating magical\nmoments with food"),
        ("clock", "Fresh food,\nRight on time"),
        ("leaf.fill", "Fresh ingredients\nHealthy meals"),
        ("hands.sparkles.fill", "Crafted with care\nJust for you")
    ]
    private var currentSymbolIndex = 0
    
    private var foodRotationTimer: Timer?
    private let foodImages = ["PaneerButterMasala", "IdliSambar", "CholeBhature", "DalMakhani", "MasalaDosa"]
    private var currentFoodIndex = 0
    
    private var placeholderTimer: Timer?
    private var dishNames = ["Search for dishes...", "Find your favorite meal...", "Discover tasty food...", "Explore new flavors..."]
    private var currentIndex = 0
    private var animatedPlaceholderLabel: UILabel?
    
    let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.navigationItem.largeTitleDisplayMode = .always
        
        // Request notification permissions
        requestNotificationPermissions()
        
        // Setup loading view
        setupLoadingView()
        
        // Start loading animation
        showLoadingIndicator()
        
        // Add refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        LandingPage.refreshControl = refreshControl
        
        // Registering Nibs for Cells
        let BannerDetailsNib = UINib(nibName: "LandingPageBanner", bundle: nil)
        let LandingPageChefSpecialNib = UINib(nibName: "LandingPageChefSpecial", bundle: nil)
        let LandingPageKitchenNib = UINib(nibName: "LandingPageKitchen", bundle: nil)
        
        LandingPage.register(BannerDetailsNib, forCellWithReuseIdentifier: "LandingPageBanner")
        LandingPage.register(LandingPageChefSpecialNib, forCellWithReuseIdentifier: "LandingPageChefSpecial")
        LandingPage.register(LandingPageKitchenNib, forCellWithReuseIdentifier: "LandingPageKitchen")
        
        // Register kitchen collection view cell if it exists
        if let kitchenCV = kitchenCollectionView {
            let kitchenNib = UINib(nibName: "LandingPageKitchenCollectionViewCell", bundle: nil)
            kitchenCV.register(kitchenNib, forCellWithReuseIdentifier: "LandingPageKitchenCollectionViewCell")
            kitchenCV.dataSource = self
            kitchenCV.delegate = self
        }
        
        // Setting Layout
        LandingPage.register(SectionHeaderLandingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderLanding")
//        header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)


        LandingPage.setCollectionViewLayout(generateLayout(), animated: true)
        LandingPage.dataSource = self
        LandingPage.delegate = self
        
        // Configure kitchen collection view
        if let kitchenCV = kitchenCollectionView {
            kitchenCV.dataSource = self
            kitchenCV.delegate = self
        }
        
        setupSearchController()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToCurrentMeal()
        }
        
        // Load initial data if needed
        Task {
            do {
                showLoadingIndicator() // Show loading indicator before starting data load
                try await KitchenDataController.loadData()
                
                // Check if data was loaded successfully
                if !KitchenDataController.kitchens.isEmpty || !KitchenDataController.menuItems.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.LandingPage.reloadData()
                        self.hideLoadingIndicator() // Hide loading indicator after successful load
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        // Show an error alert to the user
                        let alert = UIAlertController(
                            title: "Data Loading Error",
                            message: "Failed to load data. Please check your internet connection and try again.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                        self.hideLoadingIndicator() // Hide loading indicator after error
                    }
                }
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // Show an error alert to the user
                    let alert = UIAlertController(
                        title: "Data Loading Error",
                        message: "Failed to load data. Please check your internet connection and try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    self.hideLoadingIndicator() // Hide loading indicator after error
                }
            }
        }
    }
       
    
    func getCurrentMealCategoryIndex() -> Int {
        let currentHour = Calendar.current.component(.hour, from: Date())

        switch currentHour {
        case 21..<24, 0..<7:
            return 0 // Breakfast
        case 7..<11:
            return 1 // Lunch
        case 11..<16:
            return 2 // Snacks
        case 16..<21:
            return 3 // Dinner
        default:
            return 0 // Default to breakfast
        }
    }


    func scrollToCurrentMeal() {
        let currentMealIndex = getCurrentMealCategoryIndex()
        let indexPath = IndexPath(item: currentMealIndex, section: 0) // Assuming section 0 is the meal banner

        LandingPage.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let targetIndex = getCurrentMealCategoryIndex()
        let indexPath = IndexPath(item: targetIndex, section: 0)

        // Ensure the cell is visible without scrolling automatically
        DispatchQueue.main.async {
            self.LandingPage.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    
       // MARK: - Number of Sections
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 3
       }
       
       // MARK: - Number of Items in Section
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if collectionView == LandingPage {
               switch section {
               case 0:
                   return KitchenDataController.mealBanner.count
               case 1:
                   return KitchenDataController.chefSpecialtyDishes.count
               case 2:
                   return min(5, KitchenDataController.kitchens.count)
               default:
                   return 0
               }
           } else if collectionView == kitchenCollectionView {
               return KitchenDataController.kitchens.count
           }
           return 0
       }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderLanding", for: indexPath) as! SectionHeaderLandingCollectionReusableView
            
            // Switch case for section headers
            switch indexPath.section {
            case 0:
                header.headerLabel.text = KitchenDataController.sectionHeaderLandingNames[0]
            case 1:
                header.headerLabel.text = KitchenDataController.sectionHeaderLandingNames[1]
            case 2:
                header.headerLabel.text = KitchenDataController.sectionHeaderLandingNames[2]
           
            default:
                header.headerLabel.text = "Section \(indexPath.section)" // Default case to prevent out of range error
            }
            
            if header.headerLabel.text == "" {
                header.actionButton.isHidden = true
                header.headerLabel.font = UIFont.systemFont(ofSize: 0, weight: .regular)
            } else {
                header.actionButton.isHidden = false
                header.headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            }
            if header.headerLabel.text == "Meal Categories" {
                header.actionButton.isHidden = true
                header.headerLabel.font = UIFont.systemFont(ofSize: 0, weight: .regular)
            } else {
                header.actionButton.isHidden = false
                header.headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            }
            
            header.headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            header.actionButton.setTitle("See More", for: .normal)

        header.actionButton.tag = indexPath.section
        header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
             
            
            return header
        }
        print("Supplementary View Not Found")
        return UICollectionReusableView()
    }

       // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == LandingPage {
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageBanner", for: indexPath) as! LandingPageBannerCollectionViewCell
                cell.updateBannerDetails(for: indexPath)
                cell.layer.cornerRadius = 15.0
                return cell
                
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageChefSpecial", for: indexPath) as! LandingPageChefSpecialCollectionViewCell
                cell.updateSpecialDishDetails(for: indexPath)
                cell.delegate = self
                cell.layer.cornerRadius = 15.0
                return cell
                
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageKitchen", for: indexPath) as! LandingPageKitchenCollectionViewCell
                let kitchen = KitchenDataController.kitchens[indexPath.item]
                cell.updateLandingPageKitchen(for: indexPath)
                cell.layer.cornerRadius = 15.0
                return cell
            
            default:
                return UICollectionViewCell()
            }
        } else if collectionView == kitchenCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageKitchenCollectionViewCell", for: indexPath) as! LandingPageKitchenCollectionViewCell
            cell.updateLandingPageKitchen(for: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }

       
       // MARK: - Compositional Layout
       func generateLayout() -> UICollectionViewLayout {
           let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
               let section: NSCollectionLayoutSection
               switch sectionIndex {
               case 0:
                   section = self.generateBannerSectionLayout()
               case 1:
                   section = self.generateLandingChefSpecialSectionLayout()
               case 2:
                   section = self.generateLandingPageKitchenSectionLayout()
              
               default:
                   return nil
               }
               
               // Add Header
               let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.03), heightDimension: .absolute(55))
               let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
               section.boundarySupplementaryItems = [header]
               
               return section
           }
           return layout
       }
       
//       // Layout for Kitchen Details Section
       func generateBannerSectionLayout() -> NSCollectionLayoutSection {
//
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(100))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
           group.interItemSpacing = .fixed(5) // Space between items within the section
           group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 0, trailing: 8.0)
           let section = NSCollectionLayoutSection(group: group)
           section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10) // Minimize insets
           section.orthogonalScrollingBehavior = .groupPaging
           return section
       }
   
       
       // Layout for Menu Categories Section

    func generateLandingChefSpecialSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5) // Space between items within the section
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 0, trailing: 8.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

       
       // Layout for Chef's Special Section
       func generateLandingPageKitchenSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Define group size and layout
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Add content insets to the group
        group.interItemSpacing = .fixed(10)
           group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 10.0, trailing: 10.0)
        
        // Create the section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        return section
    }
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == LandingPage {
            if indexPath.section == 0 { // Section 0 corresponds to "LandingPageBanner"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let mealCategoriesVC = storyboard.instantiateViewController(withIdentifier: "MenuCategoriesViewController") as? MenuCategoriesViewController {
                    switch indexPath.row {
                    case 0:
                        mealCategoriesVC.mealTiming = .breakfast
                    case 1:
                        mealCategoriesVC.mealTiming = .lunch
                    case 2:
                        mealCategoriesVC.mealTiming = .snacks
                    case 3:
                        mealCategoriesVC.mealTiming = .dinner
                    default:
                        mealCategoriesVC.mealTiming = .snacks
                    }
                    self.navigationController?.pushViewController(mealCategoriesVC, animated: true)
                }
            } else if indexPath.section == 2 { // Kitchen section
                let selectedKitchen = KitchenDataController.kitchens[indexPath.item]
                if !selectedKitchen.isOnline {
                    return // Prevent navigation if kitchen is offline
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                    viewController.kitchenData = selectedKitchen
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        } else if collectionView == kitchenCollectionView {
            let selectedKitchen = KitchenDataController.kitchens[indexPath.row]
            print("Selected kitchen: \(selectedKitchen.name)")
            // Navigate to kitchen detail view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                viewController.kitchenData = selectedKitchen
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "LandingPageChefSpecialitySeeMoreViewController") as? LandingPageChefSpecialitySeeMoreViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenMenuListViewController")
            }
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let SecondScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenSeeMoreViewController") as? KitchenSeeMoreViewController {
                self.navigationController?.pushViewController(SecondScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenMenuListViewController")
            }

        default:
            break
        }
    }
    
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            
            if let profileVC = storyboard.instantiateInitialViewController() {
                
                navigationController?.pushViewController(profileVC, animated: true)
            }
    }
    

    
    
    func ChefSpecialaddButtonTapped(in cell: LandingPageChefSpecialCollectionViewCell) {
        guard let indexPath = LandingPage.indexPath(for: cell) else { return }
        
        // Fetch the Chef Specialty Dish from the data controller
        let selectedChefSpecialtyDish = KitchenDataController.globalChefSpecial[indexPath.row]
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
    
    
    
    
    // MARK: - Search bar
    func setupSearchController() {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.delegate = self
            searchController.searchBar.searchTextField.clearButtonMode = .never
            navigationItem.searchController = searchController
            definesPresentationContext = true

            // Set initial placeholder to avoid "Search" appearing first
            searchController.searchBar.placeholder = dishNames[currentIndex]

            if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                animatedPlaceholderLabel = UILabel(frame: searchTextField.bounds)
                animatedPlaceholderLabel?.text = dishNames[currentIndex]
                animatedPlaceholderLabel?.font = searchTextField.font
                animatedPlaceholderLabel?.textColor = .gray
                animatedPlaceholderLabel?.alpha = 1.0
                animatedPlaceholderLabel?.textAlignment = .left
                searchTextField.addSubview(animatedPlaceholderLabel!)
            }

            startPlaceholderAnimation()
        }

        private func startPlaceholderAnimation() {
            placeholderTimer?.invalidate()
            placeholderTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(animatePlaceholder), userInfo: nil, repeats: true)
        }

        @objc private func animatePlaceholder() {
            guard let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField,
                  let animatedPlaceholderLabel = animatedPlaceholderLabel else { return }

            UIView.animate(withDuration: 0.5, animations: {
                animatedPlaceholderLabel.transform = CGAffineTransform(translationX: 0, y: -10) // Move up
                animatedPlaceholderLabel.alpha = 0.0 // Fade out
            }) { _ in
                self.currentIndex = (self.currentIndex + 1) % self.dishNames.count
                let newText = self.dishNames[self.currentIndex]

                animatedPlaceholderLabel.text = newText
                searchTextField.placeholder = newText // Ensure actual placeholder updates

                // Reset position below and fade-in
                animatedPlaceholderLabel.transform = CGAffineTransform(translationX: 0, y: 10)
                UIView.animate(withDuration: 0.5) {
                    animatedPlaceholderLabel.alpha = 1.0
                    animatedPlaceholderLabel.transform = .identity
                }
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            startPlaceholderAnimation()
            LandingPage.reloadData()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            placeholderTimer?.invalidate()
        }

        deinit {
            placeholderTimer?.invalidate()
        }


       func updateSearchResults(for searchController: UISearchController) {
           // Handle search logic
       }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.addSubview(symbolImageView)
        loadingView.addSubview(quoteLabel)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 200),
            loadingView.heightAnchor.constraint(equalToConstant: 150),
            
            symbolImageView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            symbolImageView.topAnchor.constraint(equalTo: loadingView.topAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 60),
            symbolImageView.heightAnchor.constraint(equalToConstant: 60),
            
            quoteLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 15),
            quoteLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 10),
            quoteLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -10),
            quoteLabel.bottomAnchor.constraint(lessThanOrEqualTo: loadingView.bottomAnchor)
        ])
        
        loadingView.isHidden = true
    }
    
    private func showLoadingIndicator() {
        loadingView.isHidden = false
        LandingPage.isHidden = true
        startSymbolRotation()
    }
    
    private func hideLoadingIndicator() {
        loadingView.isHidden = true
        LandingPage.isHidden = false
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
                if let image = UIImage(systemName: symbolName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)) {
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
                        self.LandingPage.reloadData()
                        self.kitchenCollectionView?.reloadData()
                    }
                    
                    self.refreshControl.endRefreshing()
                    self.hideLoadingIndicator()
                }
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Show error message
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

    private func requestNotificationPermissions() {
        // First check current authorization status
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Request permission with custom alert
                DispatchQueue.main.async {
                    self.showCustomNotificationPermissionAlert()
                }
            case .denied:
                // Show alert to go to settings if previously denied
                DispatchQueue.main.async {
                    self.showGoToSettingsAlert()
                }
            case .authorized, .provisional, .ephemeral:
                print("✅ Notifications already authorized")
            @unknown default:
                break
            }
        }
    }
    
    private func showCustomNotificationPermissionAlert() {
        let alert = UIAlertController(
            title: "Stay Updated! 📱",
            message: "Enable notifications to get real-time updates about your orders and exclusive offers from RasoiChef!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Enable", style: .default) { [weak self] _ in
            self?.requestSystemNotificationPermission()
        })
        
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showGoToSettingsAlert() {
        let alert = UIAlertController(
            title: "Enable Notifications",
            message: "To receive order updates and offers, please enable notifications in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func requestSystemNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showGoToSettingsAlert()
                }
            }
        }
    }
}

extension LandingPageViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss keyboard
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        if let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchDishesViewController") as? SearchDishesViewController {
            navigationController?.pushViewController(searchVC, animated: true)
        }
    }
}
