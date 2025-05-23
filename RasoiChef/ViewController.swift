//
//  ViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, MenuDetailsCellDelegate,UICollectionViewDelegateFlowLayout, MenuListHeaderDelegate,ChefSpeacialityHeaderDelegate,MealSubscriptionPlanHeaderDelegate,
                      planYourMealDelegate,ChefSpecialLandingPageMenuDetailsCellDelegate{
    
    
   
    
    
    
    @IBOutlet var collectionView1: UICollectionView!
    var kitchenData: Kitchen?
    //    var selectedChefSpecialtyDish: ChefSpecialtyDish?
    var selectedItem: MenuItem?
    var selectedChefSpecialtyDish: ChefSpecialtyDish?
    
    // Add refresh control
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
        label.text = "Preparing your delicious meal..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private var symbolRotationTimer: Timer?
    private let symbols = [
        ("fork.knife", "Preparing your delicious meal..."),
        ("flame.fill", "Cooking with passion..."),
        ("leaf.fill", "Fresh ingredients for you..."),
        ("heart.fill", "Made with love..."),
        ("star.fill", "Quality you can taste...")
    ]
    private var currentSymbolIndex = 0
    
    //    var selectedItem: MenuItem?
    //  var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Kanha Ji Rasoi"
        self.navigationItem.largeTitleDisplayMode = .never
        
        // Setup loading view
        setupLoadingView()
        
        // Setup refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView1.refreshControl = refreshControl
        
        // Load kitchens if not already loaded
        print("🔍 Checking kitchen data...")
        if KitchenDataController.kitchens.isEmpty {
            print("🔄 Loading kitchens...")
            Task {
                do {
                    try await KitchenDataController.loadData()
                    print("✅ Successfully loaded \(KitchenDataController.kitchens.count) kitchens")
                    await MainActor.run {
                        self.collectionView1.reloadData()
                    }
                } catch {
                    print("❌ Error loading kitchens: \(error)")
                }
            }
        } else {
            print("✅ Kitchens already loaded: \(KitchenDataController.kitchens.count) kitchens")
        }
        
        // Load kitchen-specific data if a kitchen is selected
        if let kitchen = kitchenData {
            KitchenDataController.loadKitchenSpecificData(forKitchenID: kitchen.kitchenID)
            self.title = kitchen.name
        }
        
        // Load favorite kitchens
        KitchenDataController.loadFavorites()
        
        // Registering Nibs for Cells
        let kitchenDetailsNib = UINib(nibName: "KitchenDetails", bundle: nil)
        let menuDetailsNib = UINib(nibName: "MenuDetails", bundle: nil)
        let chefSpecialDishesNib = UINib(nibName: "ChefSpecialDishes", bundle: nil)
        let subscriptionDetailsNib = UINib(nibName: "SubscriptionDetails", bundle: nil)
        let MenuListHeaderNib = UINib(nibName: "MenuListHeader", bundle: nil)
        let ChefSpecialityDishesHeaderNib = UINib(nibName: "ChefSpecialityDishesHeader", bundle: nil)
        let MealSubscriptionPlanNib = UINib(nibName: "MealSubscriptionPlanHeader", bundle: nil)
        
        
        collectionView1.register(kitchenDetailsNib, forCellWithReuseIdentifier: "KitchenDetails")
        collectionView1.register(menuDetailsNib, forCellWithReuseIdentifier: "MenuDetails")
        collectionView1.register(chefSpecialDishesNib, forCellWithReuseIdentifier: "ChefSpecialDishes")
        collectionView1.register(subscriptionDetailsNib, forCellWithReuseIdentifier: "SubscriptionDetails")
        collectionView1.register(MenuListHeaderNib, forCellWithReuseIdentifier: "MenuListHeader")
        collectionView1.register(ChefSpecialityDishesHeaderNib, forCellWithReuseIdentifier: "ChefSpecialityDishesHeader")
        collectionView1.register(MealSubscriptionPlanNib, forCellWithReuseIdentifier: "MealSubscriptionPlanHeader")

        
        
        collectionView1.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView1.dataSource = self
        collectionView1.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Define standard meal type order
        let mealTypeOrder: [MealType] = [.breakfast, .lunch, .snacks, .dinner]
        
        // Get current meal type index
        let targetIndex = getCurrentMealTypeIndex()
        let targetMealType = mealTypeOrder[targetIndex]
        
        // Get sorted items
        let items = kitchenData != nil ? KitchenDataController.filteredMenuItems : KitchenDataController.menuItems
        
        // Find the first menu item of the current meal type
        if let firstIndex = items.firstIndex(where: { item in
            item.availableMealTypes == targetMealType
        }), firstIndex < items.count {
            let indexPath = IndexPath(item: firstIndex, section: 2)  // section 2 is MenuDetails
            
            // Scroll to the item only if the section has items
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      let collectionView = self.collectionView1,
                      indexPath.section < collectionView.numberOfSections,
                      indexPath.item < collectionView.numberOfItems(inSection: indexPath.section) else {
                    return
                }
                
                collectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: true
                )
            }
        }
    }
    
    private func getCurrentMealTypeIndex() -> Int {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        switch currentHour {
        case 0..<6:   return 0  // Breakfast (12 AM - 6 AM)
        case 6..<11:  return 1  // Lunch (6 AM - 11 AM)
        case 11..<15: return 2  // Snacks (11 AM - 3 PM)
        case 15..<19: return 3  // Dinner (3 PM - 7 PM)
        default:      return 0  // After 7 PM - show next day's breakfast
        }
    }
    
    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7  // Remove extra sections
    }
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Single restaurant/kitchen details
        case 1:
            return 1
        case 2:
            // Get current day
            let currentDay = Calendar.current.component(.weekday, from: Date())
            let weekdayMap: [Int: WeekDay] = [
                1: .sunday,
                2: .monday,
                3: .tuesday,
                4: .wednesday,
                5: .thursday,
                6: .friday,
                7: .saturday
            ]
            let today = weekdayMap[currentDay] ?? .monday
            
            // Filter menu items for current day
            let menuItems = kitchenData != nil ? KitchenDataController.filteredMenuItems : KitchenDataController.menuItems
            let todaysMenuItems = menuItems.filter { $0.availableDays == today }
            return todaysMenuItems.count
        case 3:
            return 1
        case 4:
            return kitchenData != nil ? KitchenDataController.filteredChefSpecialtyDishes.count : KitchenDataController.chefSpecialtyDishes.count
        case 5:
            return 1
        case 6:
            return kitchenData != nil ? KitchenDataController.filteredSubscriptionPlan.count : KitchenDataController.subscriptionPlan.count
        default:
            return 0
        }
    }
    
    
    
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenDetails", for: indexPath) as! KitchenDetailsCollectionViewCell
            cell.layer.cornerRadius = 8.0
            if let selectedKitchen = kitchenData {
                print("✅ Configuring cell with selected kitchen: \(selectedKitchen.name)")
                cell.configure(with: selectedKitchen)
            } else {
                print("✅ Configuring cell with kitchen at index: \(indexPath.row)")
                // Make sure we have kitchens data
                guard !KitchenDataController.kitchens.isEmpty else {
                    print("❌ No kitchens data available")
                    return cell
                }
                let kitchen = KitchenDataController.kitchens[indexPath.row]
                cell.configure(with: kitchen)
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuListHeader", for: indexPath) as! MenuListHeaderCollectionViewCell
            cell.delegate = self
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuDetails", for: indexPath) as! MenuDetailsCollectionViewCell
            cell.delegate = self
            
            // Get current day
            let currentDay = Calendar.current.component(.weekday, from: Date())
            let weekdayMap: [Int: WeekDay] = [
                1: .sunday,
                2: .monday,
                3: .tuesday,
                4: .wednesday,
                5: .thursday,
                6: .friday,
                7: .saturday
            ]
            let today = weekdayMap[currentDay] ?? .monday
            
            // Filter menu items for current day
            let menuItems = kitchenData != nil ? KitchenDataController.filteredMenuItems : KitchenDataController.menuItems
            let todaysMenuItems = menuItems.filter { $0.availableDays == today }
            let menuItem = todaysMenuItems[indexPath.row]
            
            cell.updateMenuDetails(with: indexPath, menuItem: menuItem)
            
            // Get current time information
            let currentHour = Calendar.current.component(.hour, from: Date())
            
            // Check if item is available based on time
            let isAvailable: Bool = {
                guard let mealType = menuItem.availableMealTypes else {
                    return false
                }
                switch mealType {
                case .breakfast where currentHour >= 6 && currentHour < 11:  return true
                case .lunch where currentHour >= 11 && currentHour < 15:     return true
                case .snacks where currentHour >= 15 && currentHour < 19:    return true
                case .dinner where currentHour >= 19 || currentHour < 6:     return true
                default: return false
                }
            }()
            
            // Apply blur effect and disable interaction if item is not available
            if !isAvailable {
                // Add blur effect
                let blurEffect = UIBlurEffect(style: .light)
                let blurView = UIVisualEffectView(effect: blurEffect)
                blurView.frame = cell.contentView.bounds
                blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurView.tag = 100 // Tag for identification
                
                // Remove existing blur if any
                cell.contentView.subviews.forEach { view in
                    if view.tag == 100 {
                        view.removeFromSuperview()
                    }
                }
                
                cell.contentView.addSubview(blurView)
                cell.contentView.sendSubviewToBack(blurView)
                
                // Disable interaction
                cell.isUserInteractionEnabled = false
                cell.addButton.isEnabled = false
                cell.contentView.alpha = 0.7
            } else {
                // Remove blur effect if exists
                cell.contentView.subviews.forEach { view in
                    if view.tag == 100 {
                        view.removeFromSuperview()
                    }
                }
                
                // Enable interaction
                cell.isUserInteractionEnabled = true
                cell.addButton.isEnabled = true
                cell.contentView.alpha = 1.0
            }
            
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialityDishesHeader", for: indexPath) as! ChefSpecialityDishesHeaderCell
            cell.delegate = self
            return cell
            
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialDishes", for: indexPath) as! ChefSpecialCollectionViewCell
            let dishes = kitchenData != nil ? KitchenDataController.filteredChefSpecialtyDishes : KitchenDataController.chefSpecialtyDishes
            cell.updateChefSpecialDetails(with: indexPath)
            cell.delegate = self
            
            return cell
            
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealSubscriptionPlanHeader", for: indexPath) as! MealSubscriptionPlanHeaderCollectionViewCell
            cell.delegate = self
            return cell
            
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionDetails", for: indexPath) as! SubscriptionDetailsCollectionViewCell
            let plans = kitchenData != nil ? KitchenDataController.filteredSubscriptionPlan : KitchenDataController.subscriptionPlan
            cell.updateSubscriptionPlanData(for: indexPath)
            cell.layer.cornerRadius = 15.0
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
                section = self.generateKitchenSectionLayout()
            case 1:
                section = self.MenuListHeaderSectionLayout()
            case 2:
                section = self.generateMenuCategorySectionLayout()
            case 3:
                section = self.generateChefSpecialityDishCollectionViewCell()
            case 4:
                section = self.generateChefSpecialSectionLayout()
            case 5:
                section = self.generateMealSubscriptionPlanHeader()
            case 6:
                section = self.generateSubscriptionPlanSectionLayout()
            default:
                return nil
            }
            
            
            return section
        }
        return layout
    }
    
    // Layout for Kitchen Details Section
    func generateKitchenSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    func MenuListHeaderSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    // Layout for Menu Categories Section
    func generateMenuCategorySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//                group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 8.0, trailing: 5.0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 5)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    func generateChefSpecialityDishCollectionViewCell() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func generateMealSubscriptionPlanHeader() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    // Layout for Chef's Special Section
    func generateChefSpecialSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
        
    }
    
    func generateSubscriptionPlanSectionLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Define group size and layout
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Add content insets to the group
        group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 20.0, trailing: 8.0) // No insets on
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    //    MARK: - For ADD button in the menu items cell
    func MenuListaddButtonTapped(in cell: MenuDetailsCollectionViewCell) {
        guard let indexPath = collectionView1.indexPath(for: cell) else { return }
        let menuItems = kitchenData != nil ? KitchenDataController.filteredMenuItems : KitchenDataController.menuItems
        let selectedItem = menuItems[indexPath.row]
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
    
    
    
    
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenMenuListViewController") as? KitchenMenuListViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenMenuListViewController")
            }
            
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let secondScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenChefSpecialViewController") as? KitchenChefSpecialViewController {
                self.navigationController?.pushViewController(secondScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenChefSpecialViewController")
            }
        case 3:
            let subscriptionVC = MealSubscriptionPlanHostingController(rootView: MealSubscriptionPlanView())
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
        default:
            break
        }
    }
    
    
    
    
    @IBAction func cross(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func didTapSeeMore() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenMenuListViewController") as? KitchenMenuListViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
        
    }
    
    func didTapSeeMore1() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "LandingPageChefSpecialitySeeMoreViewController") as? LandingPageChefSpecialitySeeMoreViewController {
            // Pass the current kitchen's data
            firstScreenVC.kitchenData = kitchenData
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
    }
    
    func didTapSeeMorePlansMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "PlansMenuViewController") as? PlansMenuViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
    }
    func didTapSeeMoreToSubscriptionPlans() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "PlansMenuViewController") as? PlansMenuViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
        
    }
    func didTapSeeMorePlanYourMeal() {
        let alert = UIAlertController(title: "",
                                      message: "This kitchen provides plans for a minimum of 2 days and a maximum of 7 days.",
                                      preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
            let subscriptionVC = MealSubscriptionPlanHostingController(rootView: MealSubscriptionPlanView())
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
        }
        
        let declineAction = UIAlertAction(title: "Decline", style: .cancel, handler: nil)
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func ChefSpecislDishaddButtonTapped(in cell: ChefSpecialCollectionViewCell) {
        guard let indexPath = collectionView1.indexPath(for: cell) else { return }
        
        // Fetch the Chef Specialty Dish from the data controller
        let selectedChefSpecialtyDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
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
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
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
        collectionView1.isHidden = true
        startSymbolRotation()
    }
    
    private func hideLoadingIndicator() {
        loadingView.isHidden = true
        collectionView1.isHidden = false
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
                
                // Reload kitchen-specific data if a kitchen is selected
                if let kitchen = kitchenData {
                    KitchenDataController.loadKitchenSpecificData(forKitchenID: kitchen.kitchenID)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Check if data was loaded successfully
                    if !KitchenDataController.kitchens.isEmpty || !KitchenDataController.menuItems.isEmpty {
                        self.collectionView1.reloadData()
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
    

