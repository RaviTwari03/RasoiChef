//
//  PlansMenuCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 30/01/25.
//

import UIKit
class PlansMenuCollectionViewCell: UICollectionViewCell {
   
    
    @IBOutlet var MenuTiming: UILabel!
    
    @IBOutlet var MealName: UILabel!
    
    @IBOutlet var MealDescription: UILabel!
    
    @IBOutlet var subscriptionView: UIView!
    @IBOutlet var MealImage: UIImageView!
    
    
    
    func updateMenuDetails(with indexPath: IndexPath) {
        applyCardStyle2()
//        addButton.layer.cornerRadius = 11
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        MenuTiming.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
//        orderDeadlineLabel.text = "Order Before 4 pm"
//        expectedDeliveryLabel.text = "Delivery Expected By 6 pm"
        MealName.text = menuItem.name
        MealDescription.text = menuItem.description
//        mealPriceLabel.text = "₹\(menuItem.price)"
//        mealRatingLabel.text = "⭐ \(menuItem.rating)"
        MealImage.image = UIImage(named: menuItem.imageURL)
//        availabiltyLabel.text = "\(menuItem.availability.map { $0.rawValue.capitalized }.joined(separator: ", "))"

        
    }
    func applyCardStyle2() {
        subscriptionView.layer.cornerRadius = 16
        subscriptionView.layer.masksToBounds = false
        subscriptionView.layer.shadowColor = UIColor.black.cgColor
        subscriptionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        subscriptionView.layer.shadowRadius = 5
        subscriptionView.layer.shadowOpacity = 0.4
        subscriptionView.backgroundColor = .white
   }

}
