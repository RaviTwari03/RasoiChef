//
//  ChefSpecialMenuCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit
protocol ChefSpecialMenuDetailsCellDelegate: AnyObject {
    func MenuListaddButtonTapped(in cell: ChefSpecialMenuCollectionViewCell)
}
class ChefSpecialMenuCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : ChefSpecialMenuDetailsCellDelegate?
    
    @IBOutlet var specialDishImage: UIImageView!
    @IBOutlet var specialDishName: UILabel!
    @IBOutlet var specialDishPrice: UILabel!
    @IBOutlet var kitchenName: UILabel!
    
    @IBOutlet var specialDishRating: UILabel!
    @IBOutlet var Distance: UILabel!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet weak var vegNonvegIcon: UIImageView!
    
    
    func updateSpecialDishDetails(with specialDish: ChefSpecialtyDish) {
        specialDishName.text = specialDish.name
        specialDishPrice.text = "₹\(specialDish.price)"
        kitchenName.text = specialDish.kitchenName
        specialDishRating.text = "\(specialDish.rating)"
        Distance.text = "\(specialDish.distance) km"
        specialDishImage.image = UIImage(named: specialDish.imageURL)

        if specialDish.mealCategory.contains(.veg) {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
    }

    @IBAction func ChefSpecialAddButtonTapped(_ sender: Any) {
        delegate?.MenuListaddButtonTapped(in: self)
    }
    
}
