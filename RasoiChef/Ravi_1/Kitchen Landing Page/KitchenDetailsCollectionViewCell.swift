//
//  KitchenDetailsCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class KitchenDetailsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var kitchenProfileImage: UIImageView!
    @IBOutlet var kitchenDistance: UILabel!
    @IBOutlet var kitchenCuisine: UILabel!
    @IBOutlet var kitchenRatings: UILabel!
    @IBOutlet var kitchenName: UILabel!
    
//    
//    func configure(with kitchen: Kitchen) {
//        // Update kitchen name
//        kitchenName.text = kitchen.name
//        
//        // Update distance
//        kitchenDistance.text = String(format: "%.1f km", kitchen.distance)
//        
//        // Update rating
//        kitchenRatings.text = String(format: "%.1f", kitchen.rating)
//        
//        // Update cuisines and veg status
//        var statusText = kitchen.isPureVeg ? "Pure Veg • " : "Mixed • "
//        statusText += kitchen.cuisines.map { $0.rawValue.capitalized }.joined(separator: ", ")
//        kitchenCuisine.text = statusText
//        
//        // Update kitchen image if available
//        if let imageUrl = URL(string: kitchen.kitchenImage) {
//            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.kitchenProfileImage.image = image
//                    }
//                }
//            }.resume()
//        } else {
//            // Set a default image
//            kitchenProfileImage.image = UIImage(named: "KitchenImage")
//        }
//    }
    
    func configure(for indexPath: IndexPath) {
        let kitchen = KitchenDataController.kitchens[indexPath.row]
        
        kitchenName.text = kitchen.name
        kitchenDistance.text = String(format: "%.1f km", kitchen.distance)
        
        // Update cuisine display for single cuisine
        if let cuisine = kitchen.cuisine {
            kitchenCuisine.text = cuisine.rawValue.capitalized
        } else {
            kitchenCuisine.text = "Not specified"
        }
        
        kitchenRatings.text = String(format: "%.1f", kitchen.rating)
        
        // Load kitchen image
        if let imageUrl = URL(string: kitchen.kitchenImage) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.kitchenProfileImage.image = image
                    }
                }
            }.resume()
        } else {
            kitchenProfileImage.image = UIImage(named: "defaultKitchenImage")
        }
    }
}
