class PlansMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, WeekDaysSelectionDelegate {
    
    enum DayOfWeek: String, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
        
        // Convert DayOfWeek to WeekDay
        func toWeekDay() -> WeekDay {
            return WeekDay(rawValue: self.rawValue) ?? .monday
        }
    }

    @IBOutlet var subscriptionPlan: UICollectionView!
    private var selectedDay: String = "Monday" // Default selection
    private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    private var currentMenuItems: [MealType: MenuItem?] = [:]
    private let orderedMealTypes: [MealType] = [.breakfast, .lunch, .snacks, .dinner]
    
    // Debug flag
    private let debug = true
    
    private func logDebug(_ message: String) {
        if debug {
            print("📝 [PlansMenu] \(message)")
        }
    }
    
    private func logError(_ message: String, error: Error? = nil) {
        if let error = error {
            print("❌ [PlansMenu] \(message): \(error.localizedDescription)")
        } else {
            print("❌ [PlansMenu] \(message)")
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Initialize with Monday's menu
        updateMenuForSelectedDay()
        logCollectionViewState("After viewDidLoad")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.title = "Plan Menu"
        
        let subscribeButton = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(didTapSeeMoreToSubscriptionPlans))
        self.navigationItem.rightBarButtonItem = subscribeButton
        
        // Registering Nibs for Cells
        subscriptionPlan.register(UINib(nibName: "PlansMenu", bundle: nil), forCellWithReuseIdentifier: "PlansMenu")
        subscriptionPlan.register(UINib(nibName: "WeekDays", bundle: nil), forCellWithReuseIdentifier: "WeekDays")
        
        subscriptionPlan.setCollectionViewLayout(generateLayout(), animated: true)
        subscriptionPlan.dataSource = self
        subscriptionPlan.delegate = self
    }

    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return days.count
        case 1:
            return orderedMealTypes.count  // Always return 4 for breakfast, lunch, snacks, dinner
        default:
            return 0
        }
    }

    // MARK: - Cell Configuration
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDays", for: indexPath) as! WeekDaysCollectionViewCell
            let day = days[indexPath.item]
            cell.configure(with: day)
            cell.delegate = self
            cell.highlightSelection(day == selectedDay)
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.accent.cgColor
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansMenu", for: indexPath) as! PlansMenuCollectionViewCell
            
            // Get the meal type for this index
            let mealType = orderedMealTypes[indexPath.item]
            
            // Get the menu item for this meal type
            if let menuItem = currentMenuItems[mealType] ?? nil {
                cell.updateMenuDetails(
                    mealType: mealType.rawValue,
                    mealName: menuItem.name,
                    mealDescription: menuItem.description,
                    mealImageName: menuItem.imageURL.isEmpty ? "default_meal" : menuItem.imageURL
                )
            } else {
                // Handle case where no menu item exists for this meal type
                cell.updateMenuDetails(
                    mealType: mealType.rawValue,
                    mealName: "No meal available",
                    mealDescription: "No meal scheduled for this time",
                    mealImageName: "default_meal"
                )
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }

    // MARK: - Day Selection
    func didSelectDay(_ day: String) {
        // First update the data
        selectedDay = day
        updateMenuForSelectedDay()
        
        // Then update UI for both sections
        UIView.performWithoutAnimation {
            // Update the days section to reflect selection
            let daySection = IndexSet(integer: 0)
            subscriptionPlan.reloadSections(daySection)
            
            // Update the menu section with new data
            let menuSection = IndexSet(integer: 1)
            subscriptionPlan.reloadSections(menuSection)
        }
    }
    
    private func updateMenuForSelectedDay() {
        // Convert selectedDay string to DayOfWeek
        let selectedDayEnum = DayOfWeek(rawValue: selectedDay.lowercased()) ?? .monday
        
        // Convert DayOfWeek to WeekDay
        let weekDayEnum = selectedDayEnum.toWeekDay()
        
        // Get menu items for selected day
        if let plan = KitchenDataController.subscriptionPlan.first,
           let dayMeals = plan.weeklyMeals?[weekDayEnum] {
            currentMenuItems = dayMeals
        } else {
            // Initialize with empty menu items for all meal types
            currentMenuItems = Dictionary(uniqueKeysWithValues: orderedMealTypes.map { ($0, nil) })
        }
    }
    
    private func logCollectionViewState(_ context: String) {
        logDebug("\n=== Collection View State: \(context) ===")
        logDebug("Number of sections: \(subscriptionPlan.numberOfSections)")
        for section in 0..<subscriptionPlan.numberOfSections {
            logDebug("Section \(section) has \(subscriptionPlan.numberOfItems(inSection: section)) items")
        }
        logDebug("Selected day: \(selectedDay)")
        logDebug("Current menu items: \(currentMenuItems.keys.map { $0.rawValue })")
        logDebug("=====================================\n")
    }

    // MARK: - Layout Generation
    func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.generateMenuCalendarSectionLayout()
            case 1:
                return self.generateMenuListSectionLayout()
            default:
                return nil
            }
        }
    }
    
    // MARK: - Week Days Layout
    func generateMenuCalendarSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.18), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 8.0, trailing: 5.0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    // MARK: - Menu List Layout
    func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        return section
    }

    // MARK: - Navigation Action
    @objc func didTapSeeMoreToSubscriptionPlans() {
        let alert = UIAlertController(title: "", message: "This kitchen provides plans for a minimum of 2 days and a maximum of 7 days.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            }
        }
        alert.addAction(acceptAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
} 