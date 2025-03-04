//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CustomiseTableDelegate, SubscribeYourPlanButtonDelegate,WeeklyPlansDelegate {
  
    
    func didSelectStartAndEndDate(startDate: String, endDate: String, dayCount: Int, orderedDays: [String]) {
        selectedStartDate = startDate
        selectedEndDate = endDate
        selectedDayCount = dayCount
        selectedOrderedDays = orderedDays

        let today = getCurrentDay()
        let reorderedDays = reorderDays(startingFrom: today, days: orderedDays)

        print("Today's day: \(today)")
        print("Original Days: \(orderedDays)")
        print("Reordered Days: \(reorderedDays)")

        // Create weeklyMeals dynamically based on selected orderedDays
        weeklyMeals = reorderedDays.map { day in
            DayMeal(day: day, meals: ["Breakfast", "Lunch", "Snacks", "Dinner"])
        }

        isDateSelected = true
        print("Filtered Meals: \(weeklyMeals.map { $0.day })")

        DispatchQueue.main.async {
            self.MealSubscriptionPlan.reloadData()
        }
    }
    func reorderDays(startingFrom today: String, days: [String]) -> [String] {
        if let index = days.firstIndex(of: today) {
            return Array(days[index...]) + Array(days[..<index])
        } else {
            return days // If today is not in the list, return as is
        }
    }
    func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Returns full weekday name (e.g., "Friday")
        return formatter.string(from: Date())
    }

    

    

    var selectedOrderedDays: [String] = []
    var filteredWeeklyMeals: [DayMeal] = [] //
    var isDateSelected = false
    var selectedDayCount: Int = 0
    var selectedStartDate: String = ""
    var selectedEndDate: String = ""
    var finalPrice: Double = 0
    var totalPrice: Int = 1400
    var hiddenButtons: [IndexPath: Bool] = [:]
    var footerCell: SubscriptionFooterTableViewCell?
    var isModificationBlocked = false
    var buttonClickCount = 0 // To track the number of button clicks
    
  
    @IBOutlet var MealSubscriptionPlan: UITableView!
    
    struct DayMeal {
        let day: String
        var meals: [String?]
    }
    
    var weeklyMeals: [DayMeal] = [
        DayMeal(day: "Monday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"]),
        DayMeal(day: "Tuesday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"]),
        DayMeal(day: "Wednesday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"]),
        DayMeal(day: "Thursday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"]),
        DayMeal(day: "Friday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"]),
        DayMeal(day: "Saturday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"]),
        DayMeal(day: "Sunday", meals: ["Breakfast", "Lunch", "Snacks", "Dinner"])
    ]
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meal Subscription Plan"
        // Register custom cells
        MealSubscriptionPlan.register(UINib(nibName: "WeeklyPlans", bundle: nil), forCellReuseIdentifier: "WeeklyPlans")
        MealSubscriptionPlan.register(UINib(nibName: "CustomiseTable2", bundle: nil), forCellReuseIdentifier: "CustomiseTable2")
        MealSubscriptionPlan.register(UINib(nibName: "SubscriptionFooter", bundle: nil), forCellReuseIdentifier: "SubscriptionFooter")
        
        MealSubscriptionPlan.dataSource = self
        MealSubscriptionPlan.delegate = self
        MealSubscriptionPlan.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Two sections
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        case 1:
            return min(selectedDayCount, weeklyMeals.count)
        case 2:
            return selectedDayCount > 1 ? 1 : 0
        default:
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyPlans", for: indexPath) as? WeeklyPlansTableViewCell else {
                fatalError("WeeklyPlansTableViewCell not found")
            }
            cell.delegate = self
            return cell

        case 1:
            guard isDateSelected else {
                return UITableViewCell()
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as? CustomiseTableTableViewCell else {
                fatalError("CustomiseTableTableViewCell not found")
            }
            
            let dayMeal = weeklyMeals[indexPath.row]
            cell.dayLabel.text = dayMeal.day

            let icons = dayMeal.meals.map { meal in
                switch meal {
                case "Breakfast": return "BreakfastIcon"
                case "Lunch": return "LunchIcon"
                case "Snacks": return "SnacksIcon"
                case "Dinner": return "DinnerIcon"
                default: return nil
                }
            }.compactMap { $0 }

            print("Setting up cell for day: \(cell.dayLabel.text ?? "Unknown")")
            cell.configureRow(withIcons: icons)
            cell.delegate = self
            return cell

        case 2:
            guard isDateSelected else { // Hide section if date is not selected
                return UITableViewCell()
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionFooter", for: indexPath) as? SubscriptionFooterTableViewCell else {
                fatalError("SubscriptionFooterTableViewCell not found")
            }
            
            footerCell = cell // Store reference for updating price
            
            let baseDayPrice = 180  
            let baseTotalPrice = selectedDayCount * baseDayPrice
            let totalDeductions = totalPricePerSection.values.reduce(0, +)
            let finalPrice = baseTotalPrice - totalDeductions

            footerCell?.PaymentLabel.text = "₹\(finalPrice)"
            cell.updateButton()
            cell.delegate = self
            return cell
            
        default:
            fatalError("Unexpected section index")
        }
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 65
        case 2:
            return 65
        default:
            return 0
        }
    }
  

   
    func showAlert() {
        let alert = UIAlertController(title: "Limit Exceeded", message: "You have exceeded the limit of modification.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    class BannerView: UIView {
        private let stackView = UIStackView()
        private let messageLabel = UILabel()
        private let actionButton = UIButton(type: .system)
        private let chevronImage = UIImageView()
        private var actionHandler: (() -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        private func setupView() {
            backgroundColor = .white
            layer.cornerRadius = 25
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 4
            
<<<<<<< HEAD
            var selectedWeeklyMeals: [WeekDay: [MealType: MenuItem?]] = [:]

            for (section, selectedTags) in selectedButtons {
                guard let day = WeekDay(rawValue: weeklyMeals[section].day) else { continue }

                if selectedWeeklyMeals[day] == nil {
                    selectedWeeklyMeals[day] = [:]
                }

                for tag in selectedTags {
                    if let mealType = MealType(rawValue: weeklyMeals[section].meals[tag] ?? "") {
                        let menuItem = MenuItem(
                            itemID: "\(section)-\(tag)",
                            kitchenID: "kitchen001",
                            kitchenName: "Kanha Ji Rasoi",
                            distance: 0.0,
                            name: mealType.rawValue,
                            description: "Delicious \(mealType.rawValue) meal",
                            price: Double(tag),
                            rating: 4.5,
                            availableMealTypes: [mealType],
                            portionSize: "Medium",
                            intakeLimit: 1,
                            imageURL: "",
                            orderDeadline: "10:00 AM",
                            availability: [],
                            availableDays: [day],
                            mealCategory: []
                        )

                        selectedWeeklyMeals[day]?[mealType] = menuItem
                    }
                }
            }

            updateFooterPrice()
            print("Final Price before passing: \(finalPrice)")

            let subscriptionPlan = SubscriptionPlan(
                planID: String(UUID().uuidString.prefix(6)),
                kitchenName: "Kanjha Ji Rasoi", userID: "user001",
                kitchenID: "kitchen001", location: "Galgotias University",
                startDate: selectedStartDate,
                endDate: selectedEndDate,
                totalPrice: finalPrice,
                planName: "Weekly Plans",
                PlanIntakeLimit: 4,
                planImage: "",
                weeklyMeals: selectedWeeklyMeals
            )

            cartVC.addSubscriptionPlan(subscriptionPlan)

            self.navigationController?.tabBarController?.selectedIndex = 2
=======
            stackView.axis = .horizontal
            stackView.spacing = 16
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            
            messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
            
            actionButton.setTitle("View Cart", for: .normal)
            actionButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
            actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
            
            chevronImage.image = UIImage(systemName: "chevron.right")
            chevronImage.tintColor = UIColor(named: "AccentColor")
            chevronImage.contentMode = .scaleAspectFit
            
            let rightContainer = UIStackView(arrangedSubviews: [actionButton, chevronImage])
            rightContainer.axis = .horizontal
            rightContainer.spacing = 4
            rightContainer.alignment = .center
            
            stackView.addArrangedSubview(messageLabel)
            stackView.addArrangedSubview(rightContainer)
            
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        @objc private func actionButtonTapped() {
            actionHandler?()
        }
        
        func configure(message: String, action: @escaping () -> Void) {
            messageLabel.text = message
            actionHandler = action
>>>>>>> App_Development
        }
    }

    func didTapSeeMorePlanYourMeal() {
        var selectedWeeklyMeals: [WeekDay: [MealType: MenuItem?]] = [:]

        for (section, selectedTags) in selectedButtons {
            guard let day = WeekDay(rawValue: weeklyMeals[section].day) else { continue }

            if selectedWeeklyMeals[day] == nil {
                selectedWeeklyMeals[day] = [:]
            }

            for tag in selectedTags {
                if let mealType = MealType(rawValue: weeklyMeals[section].meals[tag] ?? "") {
                    let menuItem = MenuItem(
                        itemID: "\(section)-\(tag)",
                        kitchenID: "kitchen001",
                        kitchenName: "Kanha Ji Rasoi",
                        distance: 0.0,
                        name: mealType.rawValue,
                        description: "Delicious \(mealType.rawValue) meal",
                        price: Double(tag),
                        rating: 4.5,
                        availableMealTypes: [mealType],
                        portionSize: "Medium",
                        intakeLimit: 1,
                        imageURL: "",
                        orderDeadline: "10:00 AM",
                        availability: [],
                        availableDays: [day],
                        mealCategory: []
                    )

                    selectedWeeklyMeals[day]?[mealType] = menuItem
                }
            }
        }

        updateFooterPrice()
        print("Final Price before passing: \(finalPrice)")

        let subscriptionPlan = SubscriptionPlan(
            planID: String(UUID().uuidString.prefix(6)),
            kitchenName: "Kanjha Ji Rasoi", userID: "user001",
            kitchenID: "kitchen001", location: "greater noida",
            startDate: selectedStartDate,
            endDate: selectedEndDate,
            totalPrice: finalPrice,
            planName: "Weekly Plans",
            PlanIntakeLimit: 4,
            planImage: "",
            weeklyMeals: selectedWeeklyMeals
        )

        // Add to cart
        CartViewController.subscriptionPlan1.append(subscriptionPlan)
        
        // Create and configure banner view
        let bannerView = BannerView()
        bannerView.configure(message: "Plan added successfully") { [weak self] in
            self?.tabBarController?.selectedIndex = 2
        }
        view.addSubview(bannerView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bannerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Animate banner appearance
        bannerView.transform = CGAffineTransform(translationX: 0, y: 100)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            bannerView.transform = .identity
        }
        
        // Hide banner after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                bannerView.transform = CGAffineTransform(translationX: 0, y: 100)
            } completion: { _ in
                bannerView.removeFromSuperview()
            }
        }
        
        // Reset UI state
        selectedButtons.removeAll()
        buttonClickCountPerSection.removeAll()
        totalPricePerSection.removeAll()
        isDateSelected = false
        selectedDayCount = 0
        selectedStartDate = ""
        selectedEndDate = ""
        selectedOrderedDays.removeAll()
        
        // Update UI
        DispatchQueue.main.async {
            self.MealSubscriptionPlan.reloadData()
        }
        
        // Update cart badge and post notification
        if let tabItems = self.tabBarController?.tabBar.items {
            let cartTabItem = tabItems[2]
            let itemCount = CartViewController.cartItems.count + CartViewController.subscriptionPlan1.count
            cartTabItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
    }

    var selectedButtons: [Int: Set<Int>] = [:]   // Tracks selected buttons per section
    var buttonClickCountPerSection: [Int: Int] = [:]  // Tracks count per section
  
    var totalPricePerSection: [Int: Int] = [:]  // Tracks deducted price per section

    func buttonClicked(inSection section: Int, withTag tag: Int) {
        print("Button Clicked! Section: \(section), Tag: \(tag)")

        // Ensure tracking for the section
        if selectedButtons[section] == nil {
            selectedButtons[section] = []
        }
        if buttonClickCountPerSection[section] == nil {
            buttonClickCountPerSection[section] = 0
        }
        if totalPricePerSection[section] == nil {
            totalPricePerSection[section] = 0
        }

        // Toggle button selection for that section only
        if selectedButtons[section]!.contains(tag) {
            print("Button \(tag) deselected in section \(section). Not adding value back.")
            selectedButtons[section]!.remove(tag)
            buttonClickCountPerSection[section]! -= 1
        } else {
            print("Button \(tag) selected in section \(section). Deducting its value.")

            if buttonClickCountPerSection[section]! >= 4 {
                print("Limit exceeded in section \(section). Showing alert.")
                showAlert()
                return
            }

            selectedButtons[section]!.insert(tag)
            totalPrice -= tag  // ✅ Deduct only once per section
            totalPricePerSection[section]! += tag
            buttonClickCountPerSection[section]! += 1
        }

        // 🔥 Debugging Info
        print("Total Price: \(totalPrice)")
        print("Section \(section) Total: \(totalPricePerSection[section]!)")
        print("Selected buttons in section \(section): \(selectedButtons[section]!)")

        // Update footer price dynamically
        updateFooterPrice()

        // Reload only the row where the button was clicked
        if let selectedIndexPath = MealSubscriptionPlan.indexPathForSelectedRow {
            hiddenButtons[selectedIndexPath] = selectedButtons[section]!.contains(tag)
            print("Reloading row at index path: \(selectedIndexPath)")
            MealSubscriptionPlan.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            print("No selected row found in MealSubscriptionPlan.")
        }
    }


    func updateFooterPrice() {
        let baseDayPrice = 180
        let baseTotalPrice = selectedDayCount * baseDayPrice
        let totalDeductions = totalPricePerSection.values.reduce(0, +)
        finalPrice = Double(Int(baseTotalPrice - totalDeductions))  // Store final price

        DispatchQueue.main.async {
            self.footerCell?.PaymentLabel.text = "₹\(self.finalPrice)"
        }
        print("Final Price before passing: \(finalPrice)")
    }


            func didAddItemToSubscriptionCart(_ item: SubscriptionPlan) {
                // Convert SubscriptionPlan to CartItem
                let cartItem = CartItem(userAdress: "", quantity: 1, menuItem: nil, subscriptionDetails: item)

                CartViewController.cartItems.append(cartItem)

                MealSubscriptionPlan.reloadData()
                
                
                
                print("Subscription plan added to cart: \(item.planID)")
            }
        func didSelectStartAndEndDate(startDate: String, endDate: String, dayCount: Int) {
               selectedStartDate = startDate
               selectedEndDate = endDate
               selectedDayCount = dayCount

               print("Updated in ViewController -> Start: \(selectedStartDate), End: \(selectedEndDate), Days: \(selectedDayCount)")
           
           isDateSelected = true
           selectedDayCount = dayCount
           print("Received total days count: \(dayCount)")
           MealSubscriptionPlan.reloadData() // Refresh table based on selected days
       }
    }
    

