//
//  LandingPageChefSpecialCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

protocol LandingPageChefSpecialDetailsCellDelegate: AnyObject {
    func ChefSpecialaddButtonTapped(in cell: LandingPageChefSpecialCollectionViewCell)
}

class LandingPageChefSpecialCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : LandingPageChefSpecialDetailsCellDelegate?
    
    @IBOutlet var specialDishImage: UIImageView!
    
    @IBOutlet var timeIcon: UIImageView!
    @IBOutlet var SpecialDishName: UILabel!
    @IBOutlet var SpecialKitchenNameLabel: UILabel!
    @IBOutlet var SpecialPriceLabel: UILabel!
    @IBOutlet var SpecialRating: UILabel!
    @IBOutlet var vegicon: UIImageView!
    
    
    @IBOutlet weak var cardView: UIView!
    
    
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        let specialDish = KitchenDataController.globalChefSpecial[indexPath.row]
        SpecialKitchenNameLabel.text = specialDish.kitchenName
        SpecialDishName.text = specialDish.name
        SpecialPriceLabel.text = "₹\(specialDish.price)"

        SpecialRating.text = "\(String(describing: specialDish.rating))"

        specialDishImage.image = UIImage(named: specialDish.imageURL)
        
        timeIcon.image = UIImage(named: "LunchIcon")
        specialDishImage.layer.cornerRadius = 10
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    func setupShadow() {
        cardView.layer.masksToBounds = false  // Allow shadow to be visible outside the cell bounds
        
        cardView.layer.cornerRadius = 15 // Rounded corners
        cardView.layer.masksToBounds = true  // Ensure content respects rounded corners
        
        // Apply shadow to contentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        
        // Set shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
        
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.ChefSpecialaddButtonTapped(in: self)
    }
    
    
}
