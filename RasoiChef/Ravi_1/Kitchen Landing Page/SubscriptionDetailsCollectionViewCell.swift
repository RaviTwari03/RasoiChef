//
//  SubscriptionDetailsCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class SubscriptionDetailsCollectionViewCell: UICollectionViewCell {
   
    
    @IBOutlet var SubscriptionNameLabel: UILabel!
    @IBOutlet var orderIntakeLimit: UILabel!
    @IBOutlet var breakfastIconImage: UIImageView!
    @IBOutlet var lunchIconImage: UIImageView!
    @IBOutlet var snacksIconImage: UIImageView!
    
    @IBOutlet var planImage: UIImageView!
    @IBOutlet var dinnerIconImage: UIImageView!
    
    
    
    
//    func updateSubscriptionPlanData(with indexPath: IndexPath) {
//        // Fetch the subscription plan details based on the index path
//        let subscriptionPlan = KitchenDataController.subscriptionPlans[indexPath.row]
//        
//        // Update the subscription name
//        SubscriptionNameLabel.text = "Plan: \(subscriptionPlan.planID)"
//        
//        // Update the intake limit (assuming meals count for intake)
//        let remainingMeals = subscriptionPlan.meals.count
//        orderIntakeLimit.text = "Meals Left: \(remainingMeals)"
//        
//        // Reset all meal type icons to hidden
//        breakfastIconImage.isHidden = true
//        lunchIconImage.isHidden = true
//        snacksIconImage.isHidden = true
//        dinnerIconImage.isHidden = true
//        
//        // Show icons based on meal types in the subscription
//        for meal in subscriptionPlan.meals {
//            switch meal.mealType {
//            case .breakfast:
//                breakfastIconImage.isHidden = false
//            case .lunch:
//                lunchIconImage.isHidden = false
//            case .snacks:
//                snacksIconImage.isHidden = false
//            case .dinner:
//                dinnerIconImage.isHidden = false
//            }
//        }
//    }
    func updateSubscriptionPlanData(for indexPath: IndexPath) {
        // Fetch the subscription plan based on the index path
        let subscriptionPlan = KitchenDataController.subscriptionPlan[indexPath.row]
        
        // Update the subscription name label
        SubscriptionNameLabel.text = subscriptionPlan.details
        
        // Update the meal intake limit (assuming meals count for intake)
        let remainingMeals = subscriptionPlan.meals.count
        orderIntakeLimit.text = "Intake Limit Left: \(remainingMeals)"
        planImage.image = UIImage(named: subscriptionPlan.planImage ?? "nil")
        
        // Update meal types for the plan
        var availableMealTypes = [String]()
        if subscriptionPlan.meals.contains(where: { $0.mealType == .breakfast }) {
            availableMealTypes.append("Breakfast")
            breakfastIconImage.isHidden = false
        } else {
            breakfastIconImage.isHidden = true
        }
        
        if subscriptionPlan.meals.contains(where: { $0.mealType == .lunch }) {
            availableMealTypes.append("Lunch")
            lunchIconImage.isHidden = false
        } else {
            lunchIconImage.isHidden = true
        }
        
        if subscriptionPlan.meals.contains(where: { $0.mealType == .snacks }) {
            availableMealTypes.append("Snacks")
            snacksIconImage.isHidden = false
        } else {
            snacksIconImage.isHidden = true
        }
        
        if subscriptionPlan.meals.contains(where: { $0.mealType == .dinner }) {
            availableMealTypes.append("Dinner")
            dinnerIconImage.isHidden = false
        } else {
            dinnerIconImage.isHidden = true
        }
        
        //        // Update plan availability (available meal types for the subscription)
        //        planAvailabilityLabel.text = "Available Meals: \(availableMealTypes.joined(separator: ", "))"
        //        
        //        // Plan image (if applicable, assuming you have an image related to each plan)
        //        if let planImageName = subscriptionPlan.image {
        //            planImageView.image = UIImage(named: planImageName)
        //        } else {
        //            planImageView.image = nil // Set default image or nil if there's no image
        //        }
        //    }
    }
    
}
