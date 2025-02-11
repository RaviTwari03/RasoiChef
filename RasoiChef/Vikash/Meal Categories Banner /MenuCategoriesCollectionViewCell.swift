//
//  MenuCategoriesCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit

class MenuCategoriesCollectionViewCell: UICollectionViewCell {
        
    var mealTiming:MealTiming = .breakfast
    
    
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var orderIntakeLimitLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var KitchenDistance: UILabel!
    
    @IBOutlet weak var Ratings: UILabel!
    
    func updateMealDetails(with indexPath: IndexPath) {
//        guard indexPath.row < KitchenDataController.GlobaldinnerMenuItems.count else {
//            print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GlobaldinnerMenuItems.count)")
//            return
//        }
//        
//        let menuItem = KitchenDataController.GlobaldinnerMenuItems[indexPath.row]
        var menuItem:MenuItem
        
        switch mealTiming {
        case .breakfast:
            guard indexPath.row < KitchenDataController.GlobalbreakfastMenuItems.count else {
                print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GlobalbreakfastMenuItems.count)")
                        return
                    }
            
            menuItem = KitchenDataController.GlobalbreakfastMenuItems[indexPath.row]
        case .lunch:
            guard indexPath.row < KitchenDataController.GloballunchMenuItems.count else {
                print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GloballunchMenuItems.count)")
                        return
                    }
            
            menuItem = KitchenDataController.GloballunchMenuItems[indexPath.row]
        case .snacks:
            guard indexPath.row < KitchenDataController.GlobalsnacksMenuItems.count else {
                print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GlobalsnacksMenuItems.count)")
                        return
                    }
            
            menuItem = KitchenDataController.GlobalsnacksMenuItems[indexPath.row]
        case .dinner:
            guard indexPath.row < KitchenDataController.GlobaldinnerMenuItems.count else {
                        print("Error: Index \(indexPath.row) is out of range. Available items: \(KitchenDataController.GlobaldinnerMenuItems.count)")
                        return
                    }
            
            menuItem = KitchenDataController.GlobaldinnerMenuItems[indexPath.row]
        }
        
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
