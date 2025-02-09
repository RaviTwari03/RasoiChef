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
        //        if section == 0  {
        //            return 1 // Number of days in the week
        //        } else {
        //            return weeklyMeals.count // Section 1 has no rows, only a footer
        //        }
        //        if section == 2 {
        //            return 1 // Number of days in the week
        //        } else {
        //            return weeklyMeals.count // Section 1 has no rows, only a footer
        //        }
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
    func buttonClicked(withTag tag: Int) {
        // Increment the button click count
        buttonClickCount += 1
        
        // Check if the limit has been exceeded
        if buttonClickCount > 4 {
            showAlert()
            return // Exit the function if the limit is exceeded
        }
        
        print("Received button tag: \(tag)")
        
        // Update the total price
        totalPrice -= tag
        
        // Update footer price dynamically
        updateFooterPrice()
        
        // Reload only the row where the button was clicked
        if let selectedIndexPath = MealSubscriptionPlan.indexPathForSelectedRow {
            hiddenButtons[selectedIndexPath] = true
            MealSubscriptionPlan.reloadRows(at: [selectedIndexPath], with: .none)
        }
    }
    
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
    
}
