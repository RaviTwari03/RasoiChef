//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CustomiseTableDelegate, SubscribeYourPlanButtonDelegate {
    
    
    
    var totalPrice: Int = 1400  // 🔥 Start total price at 1400
    var hiddenButtons: [IndexPath: Bool] = [:]
    var footerCell: SubscriptionFooterTableViewCell?
    var isModificationBlocked = false
    var buttonClickCount = 0 // To track the number of button clicks
    
  //  var totalPrice: Int = 1400 // Initial total price (40 + 60 + 40 + 60)
    //var totalPrice = KitchenDataController.subscriptionPlans[0].totalPrice
    
    @IBOutlet var MealSubscriptionPlan: UITableView!
    
    struct DayMeal {
        let day: String
        var meals: [String?] // ["Breakfast", "Lunch", "Snacks", "Dinner"]
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meal Subscription Plan"
        // Register custom cells
        MealSubscriptionPlan.register(UINib(nibName: "WeeklyPlans", bundle: nil), forCellReuseIdentifier: "WeeklyPlans")
        MealSubscriptionPlan.register(UINib(nibName: "CustomiseTable2", bundle: nil), forCellReuseIdentifier: "CustomiseTable2")
        MealSubscriptionPlan.register(UINib(nibName: "SubscriptionFooter", bundle: nil), forCellReuseIdentifier: "SubscriptionFooter")
        
        // Set the dataSource and delegate
        MealSubscriptionPlan.dataSource = self
        MealSubscriptionPlan.delegate = self
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Two sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return weeklyMeals.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Weekly Meal Plan Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyPlans", for: indexPath) as? WeeklyPlansTableViewCell else {
                fatalError("CustomiseTableCell not found")
            }
            return cell
            
            
        case 1: // Customize Table Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as? CustomiseTableTableViewCell else {
                fatalError("CustomiseTableTableViewCell not found")
            }
            
            let dayMeal = weeklyMeals[indexPath.row]
            cell.dayLabel.text = dayMeal.day
            
            // Provide icons for each meal
            let icons = dayMeal.meals.map { meal in
                switch meal {
                case "Breakfast": return "BreakfastIcon"
                case "Lunch": return "LunchIcon"
                case "Snacks": return "SnacksIcon"
                case "Dinner": return "DinnerIcon"
                default: return nil
                }
            }.compactMap { $0 } // Filter out nil values
            
            print("Setting up cell for day: \(cell.dayLabel.text ?? "Unknown")")
            cell.configureRow(withIcons: icons)
            cell.delegate = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionFooter", for: indexPath) as? SubscriptionFooterTableViewCell else {
                fatalError("CustomiseTableCell not found")
            }
            footerCell = cell // Store reference for updating price
            footerCell?.PaymentLabel.text = "\(totalPrice)"
            cell.updateButton()
            cell.delegate = self
            return cell
            
            
        default:
            fatalError("Unexpected section index")
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60 // Height for payment footer
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 45
        case 2:
            return 65
        default:
            return 0
        }
    }
    
    
    
    
    
    private func updateFooterPrice() {
        footerCell?.PaymentLabel.text = "₹\(totalPrice)"
    }
    //    var selectedButtons: [Int: Set<Int>] = [:]
    //    var buttonClickCountPerSection: [Int: Int] = [:]
    //
    //    func buttonClicked(inSection section: Int, withTag tag: Int) {
    //        // Ensure there's a set for the section
    //        if selectedButtons[section] == nil {
    //            selectedButtons[section] = []
    //        }
    //
    //        // Ensure button count tracking per section
    //        if buttonClickCountPerSection[section] == nil {
    //            buttonClickCountPerSection[section] = 0
    //        }
    //
    //        // Toggle button state
    //        if selectedButtons[section]!.contains(tag) {
    //            // If button was already selected, remove it and add back the price
    //            selectedButtons[section]!.remove(tag)
    //            totalPrice += tag
    //            buttonClickCountPerSection[section]! -= 1
    //        } else {
    //            // If button is newly selected, subtract the price
    //            if buttonClickCountPerSection[section]! >= 4 {
    //                showAlert()
    //                return
    //            }
    //            selectedButtons[section]!.insert(tag)
    //            totalPrice -= tag
    //            buttonClickCountPerSection[section]! += 1
    //        }
    //
    //        print("Received button tag: \(tag) in section: \(section)")
    //
    //        // Update footer price dynamically
    //        updateFooterPrice()
    //
    //        // Reload only the row where the button was clicked
    //        if let selectedIndexPath = MealSubscriptionPlan.indexPathForSelectedRow {
    //            hiddenButtons[selectedIndexPath] = selectedButtons[section]!.contains(tag)
    //            MealSubscriptionPlan.reloadRows(at: [selectedIndexPath], with: .none)
    //        }
    //    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Limit Exceeded", message: "You have exceeded the limit of modification.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
//    func didTapSeeMorePlanYourMeal() {
//        let storyboard = UIStoryboard(name: "Vikash", bundle: nil)
//        if let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
//            
//            // Collect selected meals into the weeklyMeals dictionary
//            var selectedWeeklyMeals: [WeekDay: [MealType: MenuItem?]] = [:]
//
//            for (section, selectedTags) in selectedButtons {
//                guard let day = WeekDay(rawValue: weeklyMeals[section].day) else { continue }
//
//                if selectedWeeklyMeals[day] == nil {
//                    selectedWeeklyMeals[day] = [:]
//                }
//
//                for tag in selectedTags {
//                    if let mealType = MealType(rawValue: weeklyMeals[section].meals[tag] ?? "") {
//                        let menuItem = MenuItem(
//                            itemID: "\(section)-\(tag)",
//                            kitchenID: "kitchen001",
//                            kitchenName: "Kanha Ji Rasoi",
//                            distance: 0.0,  // Default or calculated value
//                            name: mealType.rawValue,
//                            description: "Delicious \(mealType.rawValue) meal",
//                            price: Double(tag),  // Placeholder price, update accordingly
//                            rating: 4.5,  // Default rating
//                            availableMealTypes: [mealType],
//                            portionSize: "Medium",  // Placeholder
//                            intakeLimit: 1,  // Default limit
//                            imageURL: "",  // Placeholder or actual image URL
//                            orderDeadline: "10:00 AM",  // Default deadline
//                            availability: [],
//                            availableDays: [day],
//                            mealCategory: []
//                        )
//
//                        selectedWeeklyMeals[day]?[mealType] = menuItem
//                    }
//                }
//            }
//
//            // Create SubscriptionPlan object
//            let subscriptionPlan = SubscriptionPlan(
//                planID: UUID().uuidString,
//                userID: "user001",
//                kitchenID: "kitchen001",
//                startDate: "2025-02-13", // Provide actual start date
//                endDate: "2025-02-20",   // Provide actual end date
//                totalPrice: Double(totalPrice), // Use calculated total price
//                details: "Your customized meal plan",
//                mealCountPerDay: 4,
//                planImage: "",
//                weeklyMeals: selectedWeeklyMeals
//            )
//
//            // Create cart item with subscription details
//            let cartItem = CartItem(
//                userAdress: "User's Address",
//                quantity: 1,
//                specialRequest: nil,
//                menuItem: nil,
//                chefSpecial: nil,
//                subscriptionDetails: subscriptionPlan
//            )
//
//            // Pass data to CartViewController
//            cartVC.cartItems.append(cartItem)
//
//            self.navigationController?.pushViewController(cartVC, animated: true)
//        }
//    }
//    func didTapSeeMorePlanYourMeal() {
//        let storyboard = UIStoryboard(name: "Vikash", bundle: nil)
//        if let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
//            
//            var selectedWeeklyMeals: [WeekDay: [MealType: MenuItem?]] = [:]
//
//            for (section, selectedTags) in selectedButtons {
//                guard let day = WeekDay(rawValue: weeklyMeals[section].day) else { continue }
//
//                if selectedWeeklyMeals[day] == nil {
//                    selectedWeeklyMeals[day] = [:]
//                }
//
//                for tag in selectedTags {
//                    if let mealType = MealType(rawValue: weeklyMeals[section].meals[tag] ?? "") {
//                        let menuItem = MenuItem(
//                            itemID: "\(section)-\(tag)",
//                            kitchenID: "kitchen001",
//                            kitchenName: "Kanha Ji Rasoi",
//                            distance: 0.0,
//                            name: mealType.rawValue,
//                            description: "Delicious \(mealType.rawValue) meal",
//                            price: Double(tag),
//                            rating: 4.5,
//                            availableMealTypes: [mealType],
//                            portionSize: "Medium",
//                            intakeLimit: 1,
//                            imageURL: "",
//                            orderDeadline: "10:00 AM",
//                            availability: [],
//                            availableDays: [day],
//                            mealCategory: []
//                        )
//
//                        selectedWeeklyMeals[day]?[mealType] = menuItem
//                    }
//                }
//            }
//
//            let subscriptionPlan = SubscriptionPlan(
//                planID: UUID().uuidString,
//                userID: "user001",
//                kitchenID: "kitchen001",
//                startDate: "2025-02-13",
//                endDate: "2025-02-20",
//                totalPrice: Double(totalPrice),
//                details: "Your customized meal plan",
//                mealCountPerDay: 4,
//                planImage: "",
//                weeklyMeals: selectedWeeklyMeals
//            )
//
//            CartViewController.subscriptionPlan1.append(subscriptionPlan) // ✅ Add Subscription Plan
//            cartVC.CartItem.reloadData() // ✅ Reload to show new item
//            
//            self.navigationController?.tabBarController?.selectedIndex = 1 // ✅ Switch to Cart Tab
//        }
//    }

    func didTapSeeMorePlanYourMeal() {
        let storyboard = UIStoryboard(name: "Vikash", bundle: nil)
        if let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            
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

            let subscriptionPlan = SubscriptionPlan(
                planID: UUID().uuidString,
                userID: "user001",
                kitchenID: "kitchen001",
                startDate: "2025-02-13",
                endDate: "2025-02-20",
                totalPrice: Double(totalPrice),
                details: "Your customized meal plan",
                mealCountPerDay: 4,
                planImage: "",
                weeklyMeals: selectedWeeklyMeals
            )

            // ✅ Update the CartViewController with the new subscription plan
            cartVC.addSubscriptionPlan(subscriptionPlan)

            // ✅ Switch to the Cart tab to reflect the update
            self.navigationController?.tabBarController?.selectedIndex = 2
        }
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
//    func didAddItemToSubscriptionCart(_ item: SubscriptionPlan) {
//        // Handle navigation or UI update when "See More Plans" is clicked
//                print("See More Plans tapped")
//            }

            func didAddItemToSubscriptionCart(_ item: SubscriptionPlan) {
                // Convert SubscriptionPlan to CartItem
                let cartItem = CartItem(userAdress: "", quantity: 1, menuItem: nil, subscriptionDetails: item)

                // Add to cart
                CartViewController.cartItems.append(cartItem)

                // Reload table to reflect changes
                MealSubscriptionPlan.reloadData()
                
                // Update Tab Bar Badge
                //updateTabBarBadge()
                
                print("Subscription plan added to cart: \(item.planID)")
            }
    }
    

