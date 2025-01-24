//
//  ChefSpecialCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class ChefSpecialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var specialDishNameLabel: UILabel!
    @IBOutlet var specialDishRating: UILabel!
    @IBOutlet var specialDishPriceLabel: UILabel!
    @IBOutlet var specialDishIntakeLimtLabel: UILabel!
    @IBOutlet var specialDishAvailableLabel: UILabel!
    
    @IBOutlet var specialDishImage: UIImageView!
    
    
    
    
    func updateChefSpecialtyDetails(for indexPath: IndexPath) {
        // Ensure the index is within bounds
        guard indexPath.row >= 0 && indexPath.row < KitchenDataController.chefSpecialtyDishes.count else {
            print("Index out of range for chefSpecialtyDishes array.")
            return
        }
        
        let specialDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]

        
        specialDishNameLabel.text = specialDish.name
        specialDishPriceLabel.text = "₹\(specialDish.price)"
        specialDishRating.text = "⭐ \(specialDish.rating)"
        specialDishImage.image = UIImage(named: "CholeBhature")
            specialDishImage.image = UIImage(named: "CholeBhature")
        
    }

    
}
