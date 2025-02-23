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

    @IBOutlet var CuisineLabel: UILabel!
    @IBOutlet var Distance: UILabel!
    @IBOutlet var RatingsLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var onlineOrOfflineIcon: UIImageView!
    
    
    func updateLandingPageKitchen(for indexPath: IndexPath) {
        let restaurant = KitchenDataController.kitchens[indexPath.row]
        
        KitchenName.text = restaurant.name
        Distance.text = "\(restaurant.distance) km"
        CuisineLabel.text = restaurant.cuisines.map { $0.rawValue }.joined(separator: ", ")
        RatingsLabel.text = "\(restaurant.rating)"
        KichenImage.image = UIImage(named: restaurant.kitchenImage)
        
        if restaurant.isOnline {
                availabilityLabel.text = "Online"
                availabilityLabel.textColor = UIColor.systemGreen
                onlineOrOfflineIcon.tintColor = UIColor.systemGreen
                containerView.alpha = 1.0 // Reset opacity
                isUserInteractionEnabled = true // Enable interaction
            } else {
                availabilityLabel.text = "Offline"
                availabilityLabel.textColor = UIColor.systemGray
                onlineOrOfflineIcon.tintColor = UIColor.systemGray
                containerView.alpha = 0.8 // Dim the cell
                isUserInteractionEnabled = false // Disable interaction
            }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    func setupShadow() {
        containerView.layer.masksToBounds = false  // Allow shadow to be visible outside the cell bounds
        
        containerView.layer.cornerRadius = 15 // Rounded corners
        containerView.layer.masksToBounds = true  // Ensure content respects rounded corners
        
        // Apply shadow to contentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        
        // Set shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
        
    }
    
    
}
