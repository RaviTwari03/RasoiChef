//
//  KitchenSeeMoreCollectionViewCell.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 09/02/25.
//

import UIKit

class KitchenSeeMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var Kichen_Image: UIImageView!
    @IBOutlet var availability_Label: UILabel!
    @IBOutlet var Kitchen_Name: UILabel!

    @IBOutlet var Cuisine_Label: UILabel!
    @IBOutlet var DistanceLabel: UILabel!
    @IBOutlet var Ratings_Label: UILabel!
    @IBOutlet weak var onlineOrOfflineIcon: UIImageView!
    

    @IBOutlet weak var container_View: UIView!
    
    func updateSpecialDishDetails(with restaurant: Kitchen) {
        Kitchen_Name.text = restaurant.name
        DistanceLabel.text = "\(restaurant.distance) km"
        Cuisine_Label.text = restaurant.cuisine?.rawValue.capitalized ?? "Not specified"
        Ratings_Label.text = "\(restaurant.rating)"
        if let imageUrl = URL(string: restaurant.kitchenImage) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.Kichen_Image.image = image
                    }
                }
            }.resume()
        } else {
            Kichen_Image.image = UIImage(named: "defaultKitchenImage")
        }
        
        if restaurant.isOnline {
            availability_Label.text = "Online"
            availability_Label.textColor = UIColor.systemGreen
            onlineOrOfflineIcon.tintColor = UIColor.systemGreen
        } else {
            availability_Label.text = "Offline"
            availability_Label.textColor = UIColor.systemGray
            onlineOrOfflineIcon.tintColor = UIColor.systemGray
            container_View.alpha = 0.8
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    func setupShadow() {
        container_View.layer.masksToBounds = false  // Allow shadow to be visible outside the cell bounds
        
        container_View.layer.cornerRadius = 15 // Rounded corners
        container_View.layer.masksToBounds = true  // Ensure content respects rounded corners
        
        // Apply shadow to contentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        
        // Set shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: container_View.layer.cornerRadius).cgPath
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: container_View.layer.cornerRadius).cgPath
        
    }
    
    
}
