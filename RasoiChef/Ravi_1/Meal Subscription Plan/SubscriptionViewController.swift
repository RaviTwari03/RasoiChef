//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
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
    
    
    //           // Section Footer for Payment Button
    //           func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //               if section == 1 {
    //                   let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
    //
    //                   // Add "Pay ₹1400" label
    //                   let payLabel = UILabel(frame: CGRect(x: 16, y: 10, width: 150, height: 40))
    //                   payLabel.text = "Pay ₹1400"
    //                   payLabel.font = UIFont.boldSystemFont(ofSize: 18)
    //                   footerView.addSubview(payLabel)
    //
    //                   // Add "Subscribe Plan" button
    //                   let button = UIButton(frame: CGRect(x: tableView.frame.width - 160, y: 10, width: 140, height: 40))
    //                   button.setTitle("Subscribe Plan", for: .normal)
    //                   button.backgroundColor = .orange
    //                   button.setTitleColor(.white, for: .normal)
    //                   button.layer.cornerRadius = 10
    //                   footerView.addSubview(button)
    //
    //                   return footerView
    //               }
    //               return nil
    //           }
    //
    //
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return weeklyMeals.count
    //    }
    //
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as? CustomiseTableTableViewCell else {
    //            fatalError("CustomiseTableTableViewCell not found")
    //        }
    //
    //        cell.dayLabel.text = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][indexPath.row]
    //
    //        let icons = ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"] // Replace with your actual image names
    //        print("Setting up cell for day: \(cell.dayLabel.text ?? "Unknown")")
    //        cell.configureRow(withIcons: icons)
    //
    //        return cell
    //    }
    //
    //}
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weeklyMeals.count // Number of days in the week
        } else {
            return 0 // Section 1 has no rows, only a footer
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Weekly Meal Plan"
        } else if section == 1 {
            return nil // No title for payment section
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40 // Height for "Weekly Meal Plan" header
        } else if section == 1 {
            return 20 // Small space for Section 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as? CustomiseTableTableViewCell else {
            fatalError("CustomiseTableTableViewCell not found")
        }
        
        if indexPath.section == 0 {
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            
            // Add "Pay ₹1400" label
            let payLabel = UILabel(frame: CGRect(x: 16, y: 10, width: 150, height: 40))
            payLabel.text = "Pay ₹1400"
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60 // Height for payment footer
        }
        return 0
    }
}
