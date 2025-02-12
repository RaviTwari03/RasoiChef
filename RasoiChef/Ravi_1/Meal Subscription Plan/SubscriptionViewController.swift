//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CustomiseTableDelegate, SubscribeYourPlanButtonDelegate {
    
    
    
    var hiddenButtons: [IndexPath: Bool] = [:]
    var footerCell: SubscriptionFooterTableViewCell?
    var isModificationBlocked = false
    var buttonClickCount = 0 // To track the number of button clicks
    
    var totalPrice: Int = 1400 // Initial total price (40 + 60 + 40 + 60)
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
    func didTapSeeMorePlanYourMeal() {
        let storyboard = UIStoryboard(name: "Vikash", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
    }
    //    var selectedButtons: [Int: Set<Int>] = [:]
    //    var buttonClickCountPerSection: [Int: Int] = [:]
    //
    //    func buttonClicked(inSection section: Int, withTag tag: Int) {
    //        print("Button Clicked! Section: \(section), Tag: \(tag)")
    //
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
    //            print("Button with tag \(tag) was already selected in section \(section). Removing it...")
    //            selectedButtons[section]!.remove(tag)
    //            totalPrice += tag
    //            buttonClickCountPerSection[section]! -= 1
    //        } else {
    //            print("Button with tag \(tag) is newly selected in section \(section). Adding it...")
    //            if buttonClickCountPerSection[section]! >= 4 {
    //                print("Limit exceeded in section \(section). Showing alert.")
    //                showAlert()
    //                return
    //            }
    //            selectedButtons[section]!.insert(tag)
    //            totalPrice -= tag
    //            buttonClickCountPerSection[section]! += 1
    //        }
    //
    //        print("Updated totalPrice: \(totalPrice)")
    //        print("Button count in section \(section): \(buttonClickCountPerSection[section]!)")
    //        print("Selected buttons in section \(section): \(selectedButtons[section]!)")
    //
    //        // Update footer price dynamically
    //        updateFooterPrice()
    //
    //        // Reload only the row where the button was clicked
    //        if let selectedIndexPath = MealSubscriptionPlan.indexPathForSelectedRow {
    //            hiddenButtons[selectedIndexPath] = selectedButtons[section]!.contains(tag)
    //            print("Reloading row at index path: \(selectedIndexPath)")
    //            MealSubscriptionPlan.reloadRows(at: [selectedIndexPath], with: .none)
    //        } else {
    //            print("No selected row found in MealSubscriptionPlan.")
    //        }
    //    }
    //
    //}
    var selectedButtons: [Int: Set<Int>] = [:]  // Keeps track of selected buttons per section
    var buttonClickCountPerSection: [Int: Int] = [:]  // Keeps count per section
    var totalPricePerSection: [Int: Int] = [:]  // NEW: Track total price per section

    func buttonClicked(inSection section: Int, withTag tag: Int) {
        print("Button Clicked! Section: \(section), Tag: \(tag)")

        // Ensure section-specific tracking exists
        if selectedButtons[section] == nil {
            selectedButtons[section] = []
        }
        
        if buttonClickCountPerSection[section] == nil {
            buttonClickCountPerSection[section] = 0
        }
        
        if totalPricePerSection[section] == nil {
            totalPricePerSection[section] = 0
        }

        // Toggle button state
        if selectedButtons[section]!.contains(tag) {
            print("Button with tag \(tag) was already selected in section \(section). Removing it...")
            selectedButtons[section]!.remove(tag)
            totalPricePerSection[section]! += tag  // Restore price for the section
            buttonClickCountPerSection[section]! -= 1
        } else {
            print("Button with tag \(tag) is newly selected in section \(section). Adding it...")
            if buttonClickCountPerSection[section]! >= 4 {
                print("Limit exceeded in section \(section). Showing alert.")
                showAlert()
                return
            }
            selectedButtons[section]!.insert(tag)
            totalPricePerSection[section]! -= tag  // Deduct from section-specific price
            buttonClickCountPerSection[section]! += 1
        }
        
        print("Updated totalPrice for section \(section): \(totalPricePerSection[section]!)")
        print("Button count in section \(section): \(buttonClickCountPerSection[section]!)")
        print("Selected buttons in section \(section): \(selectedButtons[section]!)")

        // Update footer price dynamically for the section
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

}
