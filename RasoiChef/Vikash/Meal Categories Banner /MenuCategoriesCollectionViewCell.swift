//
//  MenuCategoriesCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit

class MenuCategoriesCollectionViewCell: UICollectionViewCell {
        
    var mealTiming:MealTiming = .breakfast
    
    weak var delegate: MealCategoriesCollectionViewCellDelegate?

    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var orderIntakeLimitLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var KitchenDistance: UILabel!
    
    @IBOutlet weak var Ratings: UILabel!
    
    @IBOutlet weak var vegNonVegIcon: UIImageView!
    
    
    
    
    

    
    func updateMealDetails(with menuItem: MenuItem) {
        mealNameLabel.text = menuItem.name
        mealImage.image = UIImage(named: menuItem.imageURL ?? "")
        kitchenNameLabel.text = menuItem.kitchenName
        KitchenDistance.text = "\(menuItem.distance) km"
        Ratings.text = "\(menuItem.rating)"
        orderIntakeLimitLabel.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
        priceLabel.text = "₹\(menuItem.price)"
        descriptionLabel.text = menuItem.description

        if menuItem.mealCategory.contains(.veg) {
            vegNonVegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonVegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
        
        
        // Disable "Add" button based on time
            let currentHour = Calendar.current.component(.hour, from: Date())

            switch mealTiming {
            case .breakfast:
                addButton.isEnabled = !(currentHour >= 7 && currentHour < 21)
            case .lunch:
                addButton.isEnabled = !(currentHour >= 11 && currentHour < 21)
            case .snacks:
                addButton.isEnabled = !(currentHour >= 16 && currentHour < 21)
            case .dinner:
                addButton.isEnabled = !(currentHour >= 20 && currentHour < 21)
            }

            if currentHour >= 21 || currentHour < 7 {
                addButton.isEnabled = true // Re-enable after 9 PM
            }

            addButton.alpha = addButton.isEnabled ? 1.0 : 0.8
        
        
    }

    
    
    
    

    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.MealcategoriesButtonTapped(in: self)
    }
}
//}
