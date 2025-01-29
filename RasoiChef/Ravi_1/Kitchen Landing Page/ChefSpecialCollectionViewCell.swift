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
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var specialCard: UIView!
    
    
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
        addButton.layer.cornerRadius = 11
        applyCardStyle3()
    }
    
          func applyCardStyle3() {
              specialCard.layer.cornerRadius = 16
              specialCard.layer.masksToBounds = false
              specialCard.layer.shadowColor = UIColor.black.cgColor
              specialCard.layer.shadowOffset = CGSize(width: 0, height: 4)
              specialCard.layer.shadowRadius = 5
              specialCard.layer.shadowOpacity = 0.4
              specialCard.backgroundColor = .white
         }
    
}
