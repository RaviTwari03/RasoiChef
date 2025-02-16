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
    @IBOutlet var AvailableOnDays: UILabel!
    @IBOutlet var Ratings: UILabel!
    @IBOutlet var LimitLeft: UILabel!
    
    
    
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        // Fetch the corresponding ChefSpecialtyDish for the given indexPath
        let specialDish = KitchenDataController.globalChefSpecial[indexPath.row]
        
        // Update the UI elements with the data from the specialDish object
        dishName.text = specialDish.name
        PriceOfDish.text = "₹\(specialDish.price)"
        AvailableOnDays.text = "S, Th" // Update this based on real data if
        
        Ratings.text = "\(String(describing: specialDish.rating))"
        LimitLeft.text = "Max Limit: 50"             // Update dynamically if data exists
        DishImage.image = UIImage(named: specialDish.imageURL ) 
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.ChefSpecialaddButtonTapped(in: self)
    }

}
