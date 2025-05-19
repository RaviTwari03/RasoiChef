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
        let kitchen = KitchenDataController.kitchens[indexPath.row]
        
        KitchenName.text = kitchen.name
        Distance.text = String(format: "%.1f km", kitchen.distance)
        CuisineLabel.text = kitchen.cuisine?.rawValue.capitalized ?? "Not specified"
        RatingsLabel.text = String(format: "%.1f", kitchen.rating)
        
        // Load kitchen image
        if let imageUrl = URL(string: kitchen.kitchenImage) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.KichenImage.image = image
                    }
                }
            }.resume()
        } else {
            KichenImage.image = UIImage(named: "defaultKitchenImage")
        }
        
        // Update online status
        if kitchen.isOnline {
            availabilityLabel.text = "Online"
            availabilityLabel.textColor = UIColor.systemGreen
            onlineOrOfflineIcon.tintColor = UIColor.systemGreen
        } else {
            availabilityLabel.text = "Offline"
            availabilityLabel.textColor = UIColor.systemGray
            onlineOrOfflineIcon.tintColor = UIColor.systemGray
            containerView.alpha = 0.8 // Dim the cell
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 15.0
        containerView.clipsToBounds = true
        
        // Add shadow to the cell
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        
        // Make sure the shadow path matches the corner radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
}
