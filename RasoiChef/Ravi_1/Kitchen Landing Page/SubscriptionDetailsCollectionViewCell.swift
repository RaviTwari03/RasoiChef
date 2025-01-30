//
//  SubscriptionDetailsCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class SubscriptionDetailsCollectionViewCell: UICollectionViewCell {
   
    
    @IBOutlet var sunscriptionView: UIView!
    @IBOutlet var SubscriptionNameLabel: UILabel!
    @IBOutlet var orderIntakeLimit: UILabel!
    @IBOutlet var breakfastIconImage: UIImageView!
    @IBOutlet var lunchIconImage: UIImageView!
    @IBOutlet var snacksIconImage: UIImageView!
    
    @IBOutlet var planImage: UIImageView!
    @IBOutlet var planYourMealButton: UIButton!
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
        applyCardStyle2()
        // Fetch the subscription plan based on the index path
        let subscriptionPlan = KitchenDataController.subscriptionPlan[indexPath.row]
        
        // Update the subscription name label
        SubscriptionNameLabel.text = subscriptionPlan.details
        
        // Update the meal intake limit (assuming meals count for intake)
        let remainingMeals = subscriptionPlan.meals.count
        orderIntakeLimit.text = "\(remainingMeals)"
        planImage.image = UIImage(named: subscriptionPlan.planImage ?? "nil")
        planYourMealButton.layer.cornerRadius = 11
        // Update meal types for the plan
    
    }
    func applyCardStyle2() {
        sunscriptionView.layer.cornerRadius = 16
        sunscriptionView.layer.masksToBounds = false
        sunscriptionView.layer.shadowColor = UIColor.black.cgColor
        sunscriptionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        sunscriptionView.layer.shadowRadius = 5
        sunscriptionView.layer.shadowOpacity = 0.4
        sunscriptionView.backgroundColor = .white
   }
    
}
