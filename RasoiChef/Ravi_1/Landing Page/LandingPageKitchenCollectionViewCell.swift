//
//  LandingPageKitchenCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class LandingPageKitchenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var KichenImage: UIImageView!
    @IBOutlet var availabilityLabel: UILabel!
    @IBOutlet var KitchenName: UILabel!
    @IBOutlet var ImageIcon: UIImageView!
    @IBOutlet var CuisineLabel: UILabel!
    @IBOutlet var Distance: UILabel!
    @IBOutlet var RatingsLabel: UILabel!
    
    
    func updateLandingPageKitchen(for indexPath: IndexPath) {
        
        let restaurant = KitchenDataController.kitchens[indexPath.row]
        KitchenName.text = restaurant.name
        Distance.text = "\(restaurant.distance) km"
        CuisineLabel.text = restaurant.cuisines.map { $0.rawValue }.joined(separator: ", ")
        RatingsLabel.text = "⭐ \(restaurant.rating)"
        KichenImage.image = UIImage(named: "KitchenImage 1")
        ImageIcon.image = UIImage(named: "BreakfastIcon")
        availabilityLabel.text = restaurant.isOnline ? "Online" : "Offline"
    }
}
