//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CustomiseTableDelegate, SubscribeYourPlanButtonDelegate,WeeklyPlansDelegate {

    

    
    var isDateSelected = false
    var selectedDayCount: Int = 0
    var selectedStartDate: String = ""  // e.g., "14 Feb 2025"
    var selectedEndDate: String = ""    // e.g., "20 Feb 2025"
    
    var finalPrice: Double = 0.0  // Store final price globally
    var totalPrice: Int = 1400  // 🔥 Start total price at 1400
    var hiddenButtons: [IndexPath: Bool] = [:]
    var footerCell: SubscriptionFooterTableViewCell?
    var isModificationBlocked = false
    var buttonClickCount = 0 // To track the number of button clicks
    
  
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
        MealSubscriptionPlan.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Two sections
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // guard isDateSelected else { return 0 } // Only show rows if a date is selected

        switch section {
        case 0:
            return 1 // First section always has 1 row
        case 1:
            return min(selectedDayCount, weeklyMeals.count) // Show meals only for selected days
        case 2:
            return selectedDayCount > 1 ? 1 : 0 // Show this section if more than 1 day is selected
        default:
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Weekly Meal Plan Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyPlans", for: indexPath) as? WeeklyPlansTableViewCell else {
                fatalError("WeeklyPlansTableViewCell not found")
            }
            cell.delegate = self // Set delegate to handle date selection
            return cell

        case 1: // Customize Table Section (Only visible after date selection)
            guard isDateSelected else { // Hide section if date is not selected
                return UITableViewCell()
            }
            
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
            }.compactMap { $0 } // Remove nil values

            print("Setting up cell for day: \(cell.dayLabel.text ?? "Unknown")")
            cell.configureRow(withIcons: icons)
            cell.delegate = self
            return cell

        case 2:
            // Subscription Footer (Only visible after date selection)
            guard isDateSelected else { // Hide section if date is not selected
                return UITableViewCell()
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionFooter", for: indexPath) as? SubscriptionFooterTableViewCell else {
                fatalError("SubscriptionFooterTableViewCell not found")
            }
            
            footerCell = cell // Store reference for updating price
            
            // 🔥 Calculate the final price dynamically
            let baseDayPrice = 180  // Assuming ₹200 per day
            let baseTotalPrice = selectedDayCount * baseDayPrice  // Base price based on selected days
            let totalDeductions = totalPricePerSection.values.reduce(0, +)  // Sum of deducted prices
            let finalPrice = baseTotalPrice - totalDeductions  // Compute final price

            footerCell?.PaymentLabel.text = "₹\(finalPrice)"  // ✅ Update UI with the latest price
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
  
//    private func updateFooterPrice() {
//        footerCell?.PaymentLabel.text = "₹\(totalPrice)"
//    }
   
    func showAlert() {
        let alert = UIAlertController(title: "Limit Exceeded", message: "You have exceeded the limit of modification.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


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

            updateFooterPrice()  // Ensure the final price is recalculated
            print("Final Price before passing: \(finalPrice)") // Debugging

            let subscriptionPlan = SubscriptionPlan(
                planID: UUID().uuidString,
                userID: "user001",
                kitchenID: "kitchen001",
                startDate: "14 Feb 2025",
                endDate: "20 Feb 2025",
                totalPrice: finalPrice,  // ✅ Pass updated final price
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
//    func buttonClicked(inSection section: Int, withTag tag: Int) {
//        print("Button Clicked! Section: \(section), Tag: \(tag)")
//
//        // Ensure tracking for the section
//        if selectedButtons[section] == nil {
//            selectedButtons[section] = []
//        }
//        if totalPricePerSection[section] == nil {
//            totalPricePerSection[section] = 0
//        }
//
//        // Toggle button selection
//        if selectedButtons[section]!.contains(tag) {
//            print("Button \(tag) deselected in section \(section). Adding back price.")
//            selectedButtons[section]!.remove(tag)
//            totalPricePerSection[section]! -= tag  // Add back price when deselected
//        } else {
//            print("Button \(tag) selected in section \(section). Deducting its value.")
//            
//            if selectedButtons[section]!.count >= 4 {
//                print("Limit exceeded in section \(section). Showing alert.")
//                showAlert()
//                return
//            }
//            
//            selectedButtons[section]!.insert(tag)
//            totalPricePerSection[section]! += tag  // Deduct price when selected
//        }
//
//        // 🔥 Debugging Info
//        print("Selected Days: \(selectedDayCount)")
//        print("Total Deducted Price: \(totalPricePerSection.values.reduce(0, +))")
//        print("Selected buttons in section \(section): \(selectedButtons[section]!)")
//
//        // Update footer price dynamically
//        updateFooterPrice()
//
//        // Reload only the footer section to avoid unnecessary UI updates
//        let footerIndexPath = IndexPath(row: 0, section: 2)
//        MealSubscriptionPlan.reloadRows(at: [footerIndexPath], with: .none)
//    }


    func updateFooterPrice() {
        let baseDayPrice = 180
        let baseTotalPrice = selectedDayCount * baseDayPrice
        let totalDeductions = totalPricePerSection.values.reduce(0, +)
        finalPrice = Double(baseTotalPrice - totalDeductions)  // Store final price

        DispatchQueue.main.async {
            self.footerCell?.PaymentLabel.text = "₹\(self.finalPrice)"
        }
        print("Final Price before passing: \(finalPrice)")
    }


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
    func didSelectStartAndEndDate(dayCount: Int) {
           isDateSelected = true
           selectedDayCount = dayCount
           print("Received total days count: \(dayCount)")
           MealSubscriptionPlan.reloadData() // Refresh table based on selected days
       }
    }
    

