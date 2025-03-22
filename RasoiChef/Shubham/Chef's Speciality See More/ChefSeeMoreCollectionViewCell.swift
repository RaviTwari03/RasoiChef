//
//  ChefSeeMoreCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 23/01/25.
//

import UIKit

protocol ChefSpecialMenuSeeMoreDetailsCellDelegate: AnyObject {
    func ChefSpecialaddButtonTapped(in cell: ChefSeeMoreCollectionViewCell)
}


class ChefSeeMoreCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : ChefSpecialMenuSeeMoreDetailsCellDelegate?
    
    
    @IBOutlet var DishImage: UIImageView!
    @IBOutlet var dishName: UILabel!
    @IBOutlet var PriceOfDish: UILabel!
    @IBOutlet var kitchenName: UILabel!
    @IBOutlet var Ratings: UILabel!
    @IBOutlet var Distance: UILabel!
    
    @IBOutlet weak var vegNonvegIcon: UIImageView!
    
    
    func updateSpecialDishDetails(with specialDish: ChefSpecialtyDish) {
        dishName.text = specialDish.name
        PriceOfDish.text = "₹\(specialDish.price)"
        kitchenName.text = specialDish.kitchenName
        Ratings.text = "\(specialDish.rating)"
        Distance.text = "\(specialDish.distance) km"
        
        // Load image from URL
        if let imageURL = URL(string: specialDish.imageURL) {
            loadImage(from: imageURL)
        } else {
            DishImage.image = UIImage(systemName: "photo") // Fallback image
        }

        if specialDish.mealCategory.contains(.veg) {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.DishImage.image = UIImage(systemName: "photo") // Fallback image
                }
                return
            }
            
            DispatchQueue.main.async {
                self.DishImage.image = image
            }
        }.resume()
    }

    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.ChefSpecialaddButtonTapped(in: self)
    }

}
