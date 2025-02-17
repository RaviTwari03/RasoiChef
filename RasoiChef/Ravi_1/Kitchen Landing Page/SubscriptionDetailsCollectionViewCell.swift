//
//  SubscriptionDetailsCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

protocol planYourMealDelegate: AnyObject {
    func didTapSeeMorePlanYourMeal()
    }


class SubscriptionDetailsCollectionViewCell: UICollectionViewCell {
   
    weak var delegate : planYourMealDelegate?
    
    @IBOutlet var sunscriptionView: UIView!
    @IBOutlet var SubscriptionNameLabel: UILabel!
    @IBOutlet var orderIntakeLimit: UILabel!
    @IBOutlet var breakfastIconImage: UIImageView!
    @IBOutlet var lunchIconImage: UIImageView!
    @IBOutlet var snacksIconImage: UIImageView!
    
    @IBOutlet var planImage: UIImageView!
    @IBOutlet var planYourMealButton: UIButton!
    @IBOutlet var dinnerIconImage: UIImageView!
    
    
    
    
    func updateSubscriptionPlanData(for indexPath: IndexPath) {
        // Fetch the subscription plan based on the index path
        let subscriptionPlan = KitchenDataController.subscriptionPlan[indexPath.row]
        
        // Update the subscription name label
        SubscriptionNameLabel.text = subscriptionPlan.details
        
        // Update the meal intake limit (assuming meals count for intake)
//        let remainingMeals = subscriptionPlan.meals?.count
        orderIntakeLimit.text = "\(subscriptionPlan.PlanIntakeLimit)" //"\(remainingMeals ?? 0)"
        planImage.image = UIImage(named: subscriptionPlan.planImage ?? "nil")
        planYourMealButton.layer.cornerRadius = 10
        
        // Update meal types for the plan
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    func setupShadow() {
        sunscriptionView.layer.masksToBounds = false  // Allow shadow to be visible outside the cell bounds
        
        sunscriptionView.layer.cornerRadius = 15 // Rounded corners
        sunscriptionView.layer.masksToBounds = true  // Ensure content respects rounded corners
        
        // Apply shadow to contentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        
        // Set shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: sunscriptionView.layer.cornerRadius).cgPath
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: sunscriptionView.layer.cornerRadius).cgPath
        
        
    }
    
    @IBAction func planYourMealButtton(_ sender: Any) {
        delegate?.didTapSeeMorePlanYourMeal()
    }
}
