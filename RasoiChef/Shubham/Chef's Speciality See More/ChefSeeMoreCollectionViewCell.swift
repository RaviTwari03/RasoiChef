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
    
    
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        // Fetch the corresponding ChefSpecialtyDish for the given indexPath
        let specialDish = KitchenDataController.globalChefSpecial[indexPath.row]
        
        // Update the UI elements with the data from the specialDish object
        dishName.text = specialDish.name
        PriceOfDish.text = "₹\(specialDish.price)"
        kitchenName.text = specialDish.kitchenName
        
        Ratings.text = "\(String(describing: specialDish.rating))"
        Distance.text = "\(String(describing: specialDish.distance)) km"  // Update dynamically if data exists
        DishImage.image = UIImage(named: specialDish.imageURL )
        
        if specialDish.mealCategory.contains(.veg) {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }

    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.ChefSpecialaddButtonTapped(in: self)
    }

}
