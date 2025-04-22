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
    
    var selectedKitchen: Kitchen?
    
    func configure(with kitchen: Kitchen?) {
        guard let kitchen = kitchen ?? selectedKitchen else { return }
        
        // Update kitchen details
        kitchenName.text = kitchen.name
        kitchenDistance.text = String(format: "%.1f km", kitchen.distance)
        
        // Update cuisine display
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
                } else {
                    DispatchQueue.main.async {
                        self?.kitchenProfileImage.image = UIImage(named: "defaultKitchenImage")
                    }
                }
            }.resume()
        } else {
            kitchenProfileImage.image = UIImage(named: "defaultKitchenImage")
        }
    }
    
    // Keep the existing configure(for:) method for backward compatibility
    func configure(for indexPath: IndexPath) {
        guard indexPath.row < KitchenDataController.kitchens.count else { return }
        let kitchen = KitchenDataController.kitchens[indexPath.row]
        selectedKitchen = kitchen
        configure(with: kitchen)
    }
}
