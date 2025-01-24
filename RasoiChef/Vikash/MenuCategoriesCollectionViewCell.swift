//
//  MenuCategoriesCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit

class MenuCategoriesCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealNameLabel: UILabel!

    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var orderIntakeLimitLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
   
    
    func updateMealDetails(with indexPath: IndexPath) {
        let menuItem = KitchenDataController.GloballunchMenuItems[indexPath.row]
//        vegImage.image = UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")
        mealNameLabel.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
//        ratingLabel.text = "⭐ \(menuItem.rating)"
//        dishNameLabel.text = menuItem.name
//        dishDescription.text = menuItem.description
//        dishDeliveryExpected.text = menuItem.orderDeadline
        mealImage.image = UIImage(named: menuItem.imageURL)
        orderIntakeLimitLabel.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
    }
    
}
