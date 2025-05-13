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
    @IBOutlet weak var favoritesbutton: UIButton!
    
    var selectedKitchen: Kitchen?
    
    func configure(with kitchen: Kitchen?) {
        guard let kitchen = kitchen else { return }
        // Store the kitchen for later use
        self.selectedKitchen = kitchen
        print("✅ Configured cell with kitchen: \(kitchen.name)")
        
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
        
        // Configure favorite button
        favoritesbutton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoritesbutton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoritesbutton.tintColor = .systemRed
        favoritesbutton.isSelected = kitchen.isFavorite
        
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
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        print("🔍 Favorite button tapped")
        guard let kitchen = selectedKitchen else {
            print("❌ No kitchen selected")
            return
        }
        print("✅ Found selected kitchen: \(kitchen.name)")
        
        // Toggle button state immediately for better UX
        favoritesbutton.isSelected.toggle()
        
        // Animate button
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.favoritesbutton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                self?.favoritesbutton.transform = .identity
            }
        }
        
        // Show feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        
        // Toggle favorite state in data controller
        let isFavorite = KitchenDataController.toggleFavorite(for: kitchen)
        
        // Update button state if it differs from data controller
        if favoritesbutton.isSelected != isFavorite {
            favoritesbutton.isSelected = isFavorite
        }
        
        feedbackGenerator.impactOccurred()
    }
}
