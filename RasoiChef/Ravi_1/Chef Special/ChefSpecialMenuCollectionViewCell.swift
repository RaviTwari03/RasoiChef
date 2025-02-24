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
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        // Fetch the corresponding ChefSpecialtyDish for the given indexPath
        let specialDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
        
        // Update the UI elements with the data from the specialDish object
        specialDishName.text = specialDish.name
        specialDishPrice.text = "₹\(specialDish.price)"
        kitchenName.text = specialDish.kitchenName // Update this based on real data if available
//        specialDishAvailabilityTime.text = "10:00 AM - 2:00 PM"    // Example; adjust as per your data
        specialDishRating.text = "\(String(describing: specialDish.rating))"
        Distance.text = "\(String(describing: specialDish.distance)) km"           // Update dynamically if data exists
        specialDishImage.image = UIImage(named: specialDish.imageURL ?? "placeholder") // Placeholder image if URL is nil
        addButton.layer.cornerRadius = 11
    }

    @IBAction func ChefSpecialAddButtonTapped(_ sender: Any) {
        delegate?.MenuListaddButtonTapped(in: self)
    }
    
}
