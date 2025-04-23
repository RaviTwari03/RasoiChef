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
        print("Debug - Kitchen Name: \(specialDish.kitchenName)")
        SpecialKitchenNameLabel.text = specialDish.kitchenName
        SpecialDishName.text = specialDish.name
        SpecialPriceLabel.text = "₹\(specialDish.price)"
        SpecialRating.text = "\(String(describing: specialDish.rating))"
        
        // Load image from URL
        if let imageURL = URL(string: specialDish.imageURL) {
            loadImage(from: imageURL)
        } else {
            specialDishImage.image = UIImage(systemName: "photo") // Fallback image
        }
        
        // Set timeIcon directly from assets
        timeIcon.image = UIImage(named: "LunchIcon") ?? UIImage(systemName: "clock.fill")
        specialDishImage.layer.cornerRadius = 10
        
        if specialDish.mealCategory.contains(.veg) {
            vegicon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegicon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.specialDishImage.image = UIImage(systemName: "photo") // Fallback image
                }
                return
            }
            
            DispatchQueue.main.async {
                self.specialDishImage.image = image
            }
        }.resume()
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
