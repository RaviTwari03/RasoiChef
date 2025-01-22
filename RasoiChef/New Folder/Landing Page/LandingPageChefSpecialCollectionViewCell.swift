//
//  LandingPageChefSpecialCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class LandingPageChefSpecialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var specialDishImage: UIImageView!
    
    @IBOutlet var timeIcon: UIImageView!
    @IBOutlet var SpecialDishName: UILabel!
    @IBOutlet var SpecialKitchenNameLabel: UILabel!
    @IBOutlet var SpecialPriceLabel: UILabel!
    @IBOutlet var SpecialRating: UILabel!
    
    @IBOutlet var vegicon: UIImageView!
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        let specialDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
        SpecialKitchenNameLabel.text = specialDish.kitchenName
        SpecialDishName.text = specialDish.name
        SpecialPriceLabel.text = "₹\(specialDish.price)"

        SpecialRating.text = "⭐ \(String(describing: specialDish.rating))"

        specialDishImage.image = UIImage(named: specialDish.imageURL ?? "placeholder") 
        timeIcon.image = UIImage(named: "LunchIcon")
        
    }
    
    
    
    
}
