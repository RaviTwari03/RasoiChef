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
        guard indexPath.row < KitchenDataController.GlobaldinnerMenuItems.count else {
            print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GlobaldinnerMenuItems.count)")
            return
        }
        
        let menuItem = KitchenDataController.GlobaldinnerMenuItems[indexPath.row]
        
        mealNameLabel.text = menuItem.name
        mealImage.image = UIImage(named: menuItem.imageURL)
        kitchenNameLabel.text = menuItem.kitchenName
        KitchenDistance.text = "\(menuItem.distance) km"
        Ratings.text = "\(menuItem.rating)"
        orderIntakeLimitLabel.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
        priceLabel.text = "₹\(menuItem.price)"
        descriptionLabel.text = menuItem.description
    }
}
//}
