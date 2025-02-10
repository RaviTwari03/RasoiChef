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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var KitchenDistance: UILabel!
    
    @IBOutlet weak var Ratings: UILabel!
    
    func updateMealDetails(with indexPath: IndexPath) {
        guard indexPath.row < KitchenDataController.GloballunchMenuItems.count else {
            print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GloballunchMenuItems.count)")
            return
        }
        
        let menuItem = KitchenDataController.GloballunchMenuItems[indexPath.row]
        
        mealNameLabel.text = menuItem.name
        mealImage.image = UIImage(named: menuItem.imageURL)
        kitchenNameLabel.text = menuItem.name
        orderIntakeLimitLabel.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
        priceLabel.text = "₹\(menuItem.price)"
        descriptionLabel.text = menuItem.description
    }
}
//}
