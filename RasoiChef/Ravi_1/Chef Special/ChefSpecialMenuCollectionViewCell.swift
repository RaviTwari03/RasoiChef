//
//  ChefSpecialMenuCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class ChefSpecialMenuCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var specialDishImage: UIImageView!
    @IBOutlet var specialDishName: UILabel!
    @IBOutlet var specialDishPrice: UILabel!
    @IBOutlet var specialDishAvailabilityDays: UILabel!
    
    @IBOutlet var specialDishAvailabilityTime: UILabel!
    
    @IBOutlet var specialDishRating: UILabel!
    @IBOutlet var specialDishIntakeLimit: UILabel!
    
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        // Fetch the corresponding ChefSpecialtyDish for the given indexPath
        let specialDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
        
        // Update the UI elements with the data from the specialDish object
        specialDishName.text = specialDish.name
        specialDishPrice.text = "₹\(specialDish.price)"
        specialDishAvailabilityDays.text = "Available on Weekends" // Update this based on real data if available
        specialDishAvailabilityTime.text = "10:00 AM - 2:00 PM"    // Example; adjust as per your data
        specialDishRating.text = "⭐ \(String(describing: specialDish.rating))"
        specialDishIntakeLimit.text = "Max Limit: 50"             // Update dynamically if data exists
        specialDishImage.image = UIImage(named: specialDish.imageURL ?? "placeholder") // Placeholder image if URL is nil
    }

    
}
