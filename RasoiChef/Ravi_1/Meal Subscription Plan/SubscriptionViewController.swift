//
//  SubscriptionViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class SubscriptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet var MealSubscriptionPlan: UITableView!
    
    let mealIcons: [[String]] = [
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"], // Monday
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"], // Tuesday
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"], // Wednesday
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"], // Thursday
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"], // Friday
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"], // Saturday
           ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"]  // Sunday
       ]


    override func viewDidLoad() {
           super.viewDidLoad()
           self.title = "Meal Subscription Plan"
           // Register custom cells
           MealSubscriptionPlan.register(UINib(nibName: "WeeklyPlans", bundle: nil), forCellReuseIdentifier: "WeeklyPlans")
           MealSubscriptionPlan.register(UINib(nibName: "CustomiseTable", bundle: nil), forCellReuseIdentifier: "CustomiseTable")
           
           // Set the dataSource and delegate
           MealSubscriptionPlan.dataSource = self
           MealSubscriptionPlan.delegate = self
       }

       func numberOfSections(in tableView: UITableView) -> Int {
           return 2 // Weekly Plans and Customize Table
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if indexPath.section == 0 {
              
               let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyPlans", for: indexPath) as! WeeklyPlansTableViewCell
              
               return cell
           } else {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiseTable", for: indexPath) as? CustomiseTableTableViewCell else {
                           return UITableViewCell()
                       }

                       // Configure the cell with icons for the respective day
                       let iconsForDay = mealIcons[indexPath.row]
                       cell.configureRow(withIcons: iconsForDay)

                       return cell
                   }
           }
       }

       // Helper to return the day name based on row index
       func getDayForIndex(index: Int) -> String {
           let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
           return days[index]
       }

       // Section Footer for Payment Button
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
           return section == 1 ? 60 : 0
       }
   

