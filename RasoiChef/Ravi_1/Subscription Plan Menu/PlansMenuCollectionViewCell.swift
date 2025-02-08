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
    
    
    
//    func updateMenuDetails(with indexPath: IndexPath) {
//        applyCardStyle2()
//        let menuItem = KitchenDataController.menuItems[indexPath.row]
//        MenuTiming.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
//        MealDescription.text = menuItem.description
//        MealImage.image = UIImage(named: menuItem.imageURL)
//
//        
//    }
//    func applyCardStyle2() {
//        subscriptionView.layer.cornerRadius = 16
//        subscriptionView.layer.masksToBounds = false
//        subscriptionView.layer.shadowColor = UIColor.black.cgColor
//        subscriptionView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        subscriptionView.layer.shadowRadius = 5
//        subscriptionView.layer.shadowOpacity = 0.4
//        subscriptionView.backgroundColor = .white
//   }
//
//}
    func updateMenuDetails(mealType: String, mealName: String) {
            applyCardStyle2()
            
            MenuTiming.text = mealType
            MealName.text = mealName
            MealDescription.text = "Delicious \(mealName) crafted with fresh ingredients."
            
            // Set default image if no image is available
            let imageName = mealName.replacingOccurrences(of: " ", with: "_").lowercased()
            MealImage.image = UIImage(named: imageName) ?? UIImage(named: "default_meal")
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
