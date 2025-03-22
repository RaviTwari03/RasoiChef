//
//  LandingPageKitchenCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class LandingPageKitchenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var kitchenImage: UIImageView!
    @IBOutlet var kitchenName: UILabel!
    @IBOutlet var kitchenDistance: UILabel!
    @IBOutlet var kitchenRating: UILabel!
    @IBOutlet var kitchenCuisine: UILabel!
    @IBOutlet var onlineStatus: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var onlineOrOfflineIcon: UIImageView!
    
    func configure(with kitchen: Kitchen) {
        // Update kitchen name
        kitchenName.text = kitchen.name
        
        // Update distance
        kitchenDistance.text = String(format: "%.1f km", kitchen.distance)
        
        // Update rating
        kitchenRating.text = String(format: "%.1f", kitchen.rating)
        
        // Update online status
        onlineStatus.text = kitchen.isOnline ? "Online" : "Offline"
        onlineStatus.textColor = kitchen.isOnline ? .systemGreen : .systemRed
        
        // Update cuisines and veg status
        var statusText = kitchen.isPureVeg ? "Pure Veg • " : "Mixed • "
        statusText += kitchen.cuisines.map { $0.rawValue.capitalized }.joined(separator: ", ")
        kitchenCuisine.text = statusText
        
        // Update kitchen image if available
        if let imageUrl = URL(string: kitchen.kitchenImage) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.kitchenImage.image = image
                    }
                }
            }.resume()
        } else {
            // Set a default image
            kitchenImage.image = UIImage(named: "KitchenImage")
        }
    }
    
    func updateLandingPageKitchen(for indexPath: IndexPath) {
        let kitchen = KitchenDataController.kitchens[indexPath.row]
        configure(with: kitchen)
        
        if kitchen.isOnline {
            onlineOrOfflineIcon.tintColor = .systemGreen
        } else {
            onlineOrOfflineIcon.tintColor = .systemGray
            containerView.alpha = 0.8 // Dim the cell
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
