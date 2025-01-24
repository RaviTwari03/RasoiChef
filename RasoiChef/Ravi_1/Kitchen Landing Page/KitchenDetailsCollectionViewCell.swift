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
    
    
    func updateKitchenDetails() {
        
        let restaurant = KitchenDataController.kitchens.first!
        kitchenName.text = restaurant.name
        kitchenDistance.text = "\(restaurant.distance) km"
        kitchenCuisine.text = restaurant.cuisines.map { $0.rawValue }.joined(separator: ", ")
        kitchenRatings.text = "⭐ \(restaurant.rating)"
        kitchenProfileImage.image = UIImage(named: "KitchenImage")
    }
}
