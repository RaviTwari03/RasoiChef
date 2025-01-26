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
    
    //       func numberOfSections(in tableView: UITableView) -> Int {
    //           return 2 // Weekly Plans and Customize Table
    //       }
    //
    //       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //           return 1
    //       }
    //
    //       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //           if indexPath.section == 0 {
    //
    //               let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyPlans", for: indexPath) as! WeeklyPlansTableViewCell
    //
    //               return cell
    //           } else {
    //               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable", for: indexPath) as? CustomiseTableTableViewCell else {
    //                           return UITableViewCell()
    //                       }
    //
    //                       // Configure the cell with icons for the respective day
    //                       let iconsForDay = mealIcons[indexPath.row]
    //                       cell.configureRow(withIcons: iconsForDay)
    //
    //                       return cell
    //                   }
    //           }
    //       }
    //
    //       // Helper to return the day name based on row index
    //       func getDayForIndex(index: Int) -> String {
    //           let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    //           return days[index]
    //       }
    //
    //       // Section Footer for Payment Button
    //       func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //           if section == 1 {
    //               let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
    //
    //               // Add "Pay ₹1400" label
    //               let payLabel = UILabel(frame: CGRect(x: 16, y: 10, width: 150, height: 40))
    //               payLabel.text = "Pay ₹1400"
    //               payLabel.font = UIFont.boldSystemFont(ofSize: 18)
    //               footerView.addSubview(payLabel)
    //
    //               // Add "Subscribe Plan" button
    //               let button = UIButton(frame: CGRect(x: tableView.frame.width - 160, y: 10, width: 140, height: 40))
    //               button.setTitle("Subscribe Plan", for: .normal)
    //               button.backgroundColor = .orange
    //               button.setTitleColor(.white, for: .normal)
    //               button.layer.cornerRadius = 10
    //               footerView.addSubview(button)
    //
    //               return footerView
    //           }
    //           return nil
    //       }
    //
    //       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //           return section == 1 ? 60 : 0
    //       }
    //
    //
    //    override func viewDidLoad() {
    //            super.viewDidLoad()
    //        MealSubscriptionPlan.delegate = self
    //        MealSubscriptionPlan.dataSource = self
    //
    //            // Register the custom cell
    //            let nib = UINib(nibName: "CustomiseTable", bundle: nil)
    //        MealSubscriptionPlan.register(nib, forCellReuseIdentifier: "CustomiseTable2")
    //        }
    //
    //        func numberOfSections(in tableView: UITableView) -> Int {
    //            return 2
    //        }
    //
    //        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //            return 2
    //        }
    //
    //        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as? CustomiseTableTableViewCell else {
    //                fatalError("Unable to dequeue CustomiseCell")
    //            }
    //
    //            let dayMeals = mealIcons[indexPath.section]
    //            cell.configure(dayMeals: dayMeals)
    //
    //            return cell
    //        }
    //
    //        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //            return 60
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyMeals.count
    }
    
    //        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as! CustomiseTableTableViewCell
    //
    //            let dayMeal = weeklyMeals[indexPath.row]
    //            cell.dayLabel.text = dayMeal.day
    //
    //            // Set button titles or images
    //            cell.breakfastButton.setTitle(dayMeal.meals[0] ?? "", for: .normal)
    //            cell.lunchButton.setTitle(dayMeal.meals[1] ?? "", for: .normal)
    //            cell.snacksButton.setTitle(dayMeal.meals[2] ?? "", for: .normal)
    //            cell.dinnerButton.setTitle(dayMeal.meals[3] ?? "", for: .normal)
    //
    //            // Add button actions
    //            cell.breakfastButton.tag = indexPath.row * 4 + 0
    //            cell.lunchButton.tag = indexPath.row * 4 + 1
    //            cell.snacksButton.tag = indexPath.row * 4 + 2
    //            cell.dinnerButton.tag = indexPath.row * 4 + 3
    //            cell.breakfastButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    //            cell.lunchButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    //            cell.snacksButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    //            cell.dinnerButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    //
    //            return cell
    //        }
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable2", for: indexPath) as! CustomiseTableTableViewCell
        
        let dayMeal = weeklyMeals[indexPath.row]
        cell.configure(day: dayMeal.day, meals: dayMeal.meals)
        
        // Handle button taps
        cell.buttonAction = { [weak self] button in
            guard let self = self else { return }
            
            let column = button == cell.Breakfastbutton ? 0 :
            button == cell.LunchButton ? 1 :
            button == cell.SnacksButton ? 2 : 3
            
            // Update model
            self.weeklyMeals[indexPath.row].meals[column] = nil
            
            // Reload the specific row
            self.MealSubscriptionPlan.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
}
