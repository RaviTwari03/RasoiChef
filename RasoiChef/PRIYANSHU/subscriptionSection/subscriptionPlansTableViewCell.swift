//
//  subscriptionPlansTableViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 22/01/25.
//

import UIKit

class subscriptionPlansTableViewCell: UITableViewCell,SubscriptionPlanDelegate {
   
    
    //var Subscriptionplan:SubscriptionPlan?
    var subscriptionPlan: SubscriptionPlan?
    //        didSet {
    //            updateUI()
    //        }
    //    }
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kitchenName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var symbol: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    
    private func applyCardStyle() {
        // Round the corners of the content view to make it appear as a card
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        // Add shadow to create a card-like appearance
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.masksToBounds = false
        // Add padding by adjusting the content insets
        cardView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        
        // Optionally, you can add a background color for the card
        cardView.backgroundColor = .white
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCardStyle()
        contentView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //    func configureWithSubscription(_ subscription: SubscriptionPlan) {
    //        // Set the plan name, or get it from the subscription if it exists
    //        planName.text = subscription.kitchenName ?? "Weekly Plan"
    //        
    //        // Safely unwrap and format dates
    //        let startDate = subscription.startDate ?? "N/A"
    //        let endDate = subscription.endDate ?? "N/A"
    //        dateLabel.text = "\(startDate) - \(endDate)"
    //        
    //        // Safely unwrap and format the price
    //        let formattedPrice = String(format: "₹%.2f", subscription.totalPrice ?? 0.0)
    //        symbol.text = formattedPrice
    //    }
    //
    //}
    func configureWithSubscription(_ subscription: SubscriptionPlan) {
        print("Configuring with subscription: \(subscription)")  // Log the entire subscription object
        
        // Set the plan name, or get it from the subscription if it exists
        planName.text = subscription.kitchenName ?? "Weekly Plan"
        
        // Safely unwrap and format dates
        let startDate = subscription.startDate ?? "N/A"
        let endDate = subscription.endDate ?? "N/A"
        print("Start Date: \(startDate), End Date: \(endDate)")  // Log the dates
        dateLabel.text = "\(startDate) - \(endDate)"
        
        // Safely unwrap and format the price
        let formattedPrice = String(format: "₹%.2f", subscription.totalPrice ?? 0.0)
        print("Formatted Price: \(formattedPrice)")  // Log the formatted price
        symbol.text = formattedPrice
    }
    func didAddSubscriptionPlan(_ plan: SubscriptionPlan) {
        print(subscriptionPlan)
    }
    
}

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        applyCardStyle()
//
//
//
//        contentView.layer.cornerRadius = 10
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
////    func configureWithSubscription(_ subscription: SubscriptionPlan) {
////        planName.text = "Weekly Plan"
////
////        // Safe unwrapping for startDate and endDate
//////        let startDate = subscription.startDate ?? "N/A"
//////        let endDate = subscription.endDate ?? "N/A"
////
////        // Safe unwrapping and formatting for totalPrice
////        let totalPrice = String(format: "₹%.2f", subscription.totalPrice ?? 0.0)
////
//////        dateLabel.text = "\(startDate) - \(endDate)"
//////        subscriptionPrice1.text = totalPrice
//////        quantityLabel1.text = "1" // Default to 1 for subscription
//////        increaseStepper1.value = 1
////    }
////    func configureWithSubscription(_ subscription: SubscriptionPlan) {
////        planName.text = "Weekly Plan"
////
////        // Safe unwrapping for startDate and endDate
////        let startDate = subscription.startDate ?? "N/A"
////        let endDate = subscription.endDate ?? "N/A"
////        dateLabel.text = "\(startDate) - \(endDate)"
////
////        // Safe unwrapping and formatting for totalPrice
//////        if let price = subscription.totalPrice {
//////            subscriptionPrice1.text = String(format: "₹%.2f", price)
//////        } else {
//////            subscriptionPrice1.text = "₹0.00" // Fallback for missing price
//////        }
////
//////        quantityLabel1.text = "1" // Default to 1 for subscription
//////        increaseStepper1.value = 1
////    }
//

//
//
//    func configure(subscription: SubscriptionPlan) {
//        orderIDLabel.text = "Plan ID - \(subscription.planID ?? "N/A")"
//        dateLabel.text = formatDate(subscription.startDate) + " - " + formatDate(subscription.endDate)
//        locationLabel.text = "Kitchen: \(subscription.kitchenID ?? "N/A")"
//        kitchenName.text = subscription.details ?? "Subscription Plan"
//        planName.text = "Meals per Day: \(subscription.PlanIntakeLimit ?? 0)"
//        symbol.text = "🍽️" // You can update this to display icons dynamically
//
//    }
//    private func formatDate(_ dateString: String?) -> String {
//        guard let dateString = dateString else { return "N/A" }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd" // Adjust if needed
//        if let date = formatter.date(from: dateString) {
//            formatter.dateStyle = .medium
//            return formatter.string(from: date)
//        }
//        return "Invalid Date"
//    }
//
//
//
//
//
//
//}
//extension subscriptionPlansTableViewCell: SubscriptionPlanDelegate {
//    func didAddSubscriptionPlan(_ plan: SubscriptionPlan) {
//        self.Subscriptionplan = plan
//        orderIDLabel.text = plan.planID ?? "N/A"
//        dateLabel.text = "\(plan.startDate ?? "") - \(plan.endDate ?? "")"
//        kitchenName.text = plan.kitchenID ?? "N/A"
//        planName.text = plan.details ?? "No Plan Name"
//    }
//}
/// Updates the UI when `subscriptionPlan` is set
//     func updateUI() {
//        guard let plan = subscriptionPlan else { return }
//
//        orderIDLabel.text = plan.planID ?? "N/A"
//        dateLabel.text = "\(plan.startDate ?? "") - \(plan.endDate ?? "")"
//        kitchenName.text = plan.kitchenID ?? "N/A"
//        planName.text = plan.details ?? "No Plan Name"
//        locationLabel.text = "Some Location"  // Update as per actual data
//        symbol.text = "₹\(plan.totalPrice ?? 0.0)" // Assuming it's a price label
//    }

/// Configures the cell with a `SubscriptionPlan`
//        func configureWithSubscription(_ subscription: SubscriptionPlan) {
//            planName.text = "Weekly Plan"
//
//            // Safe unwrapping for startDate and endDate
//            let startDate = subscription.startDate ?? "N/A"
//            let endDate = subscription.endDate ?? "N/A"
//            dateLabel.text = "\(startDate) - \(endDate)"
//
//            // Safe unwrapping and formatting for totalPrice
//            if let price = subscription.totalPrice {
//                subscriptionPrice1.text = String(format: "₹%.2f", price)
//            } else {
//                subscriptionPrice1.text = "₹0.00" // Fallback for missing price
//            }
//
//            quantityLabel1.text = "1" // Default to 1 for subscription
//            increaseStepper1.value = 1
//        }
//    }
