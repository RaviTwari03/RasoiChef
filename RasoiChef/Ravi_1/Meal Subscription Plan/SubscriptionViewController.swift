//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CustomiseTableDelegate {
//    func buttonClicked(withTag tag: Int) {
//        <#code#>
//    }
//    
    
    
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
        
        // Set the dataSource and delegate
        MealSubscriptionPlan.dataSource = self
        MealSubscriptionPlan.delegate = self
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Number of days in the week
        } else {
            return weeklyMeals.count // Section 1 has no rows, only a footer
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
            
        default:
            fatalError("Unexpected section index")
        }
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 1: // Customize Table Section
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as? CustomiseTableTableViewCell else {
//                fatalError("CustomiseTableTableViewCell not found")
//            }
//            
//            let dayMeal = weeklyMeals[indexPath.row]
//            cell.dayLabel.text = dayMeal.day
//            
//            // Provide icons for each meal
//            let icons = dayMeal.meals.map { meal in
//                switch meal {
//                case "Breakfast": return "BreakfastIcon"
//                case "Lunch": return "LunchIcon"
//                case "Snacks": return "SnacksIcon"
//                case "Dinner": return "DinnerIcon"
//                default: return nil
//                }
//            }.compactMap { $0 } // Filter out nil values
//            
//            print("Setting up cell for day: \(cell.dayLabel.text ?? "Unknown")")
//            cell.configureRow(withIcons: icons)
//            
//            // Set the delegate
//            cell.delegate = self
//            
//            return cell
//        default:
//            fatalError("Unexpected section index")
//        }
//    }

    
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            if section == 1 {
                let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
                
                // Add "Pay ₹" label
                let payLabel = UILabel(frame: CGRect(x: 16, y: 10, width: 150, height: 40))
                payLabel.tag = 100 // Use a tag to update this label dynamically
                payLabel.text = "Pay ₹\(totalPrice)"
                payLabel.font = UIFont.boldSystemFont(ofSize: 18)
                footerView.addSubview(payLabel)
                
                // Add "Subscribe Plan" button
                let button = UIButton(frame: CGRect(x: tableView.frame.width - 160, y: 10, width: 140, height: 40))
                button.setTitle("Subscribe Plan", for: .normal)
                button.backgroundColor = .orange
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 10
                footerView.addSubview(button)
                
                return footerView
            }
        return nil
    }
//    private func updateFooterPrice() {
//           if let footerView = MealSubscriptionPlan.footerView(forSection: 1),
//              let payLabel = footerView.viewWithTag(100) as? UILabel {
//               payLabel.text = "Pay ₹\(totalPrice)"
//           }
//       }
       

    
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
        default:
            return 0
        }
    }
//    func buttonClicked(withTag tag: Int) {
//            print("Received button tag: \(tag)")
//            
//            // Update the total price
//            totalPrice -= tag
//            
//            // Update the footer label
//            updateFooterPrice()
//        let footerSectionIndex = 1
//               MealSubscriptionPlan.reloadSections(IndexSet(integer: footerSectionIndex), with: .none)
//
//        }
    func buttonClicked(withTag tag: Int) {
        print("Received button tag: \(tag)")
        
        // Update the total price
        totalPrice -= tag
        
        // Update the footer label
        updateFooterPrice()

        // Find the index path of the clicked cell
        if let indexPath = MealSubscriptionPlan.indexPathForSelectedRow {
            // Reload the row to update button visibility
            MealSubscriptionPlan.reloadRows(at: [indexPath], with: .none)
        }

        // Reload the footer section to update the total price
        let footerSectionIndex = 1
        MealSubscriptionPlan.reloadSections(IndexSet(integer: footerSectionIndex), with: .none)
    }

//    func buttonClicked(withTag tag: Int) {
//        print("Received button tag: \(tag)")
//        
//        // Update the total price
//        totalPrice -= tag
//        
//        // Reload the footer by refreshing the entire section
//        let footerSectionIndex = 1
//        MealSubscriptionPlan.reloadSections(IndexSet(integer: footerSectionIndex), with: .none)
//    }

        private func updateFooterPrice() {
            if let footerView = MealSubscriptionPlan.footerView(forSection: 1),
               let payLabel = footerView.viewWithTag(100) as? UILabel {
                payLabel.text = "Pay ₹\(totalPrice)"
            }
        }
    
    }

