//
//  KitchenMenuCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

protocol KitchenMenuDetailsCellDelegate: AnyObject {
    func KitchenMenuListaddButtonTapped(in cell: KitchenMenuCollectionViewCell)
}


class KitchenMenuCollectionViewCell: UICollectionViewCell  {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        applyCardStyle1()
    }
  
    
    @IBOutlet var vegImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var dishNameLabel: UILabel!
    @IBOutlet var dishDescription: UILabel!
    @IBOutlet var dishprice: UILabel!
    @IBOutlet var dishImge: UIImageView!
    @IBOutlet var dishTime: UILabel!
    @IBOutlet var dishDeliveryExpected: UILabel!
    
    @IBOutlet var cardViewKitchenMenu: UIView!
    @IBOutlet var dishIntakLimit: UILabel!
    
    weak var delegate: KitchenMenuDetailsCellDelegate?
    
    func updateMealDetails(with indexPath: IndexPath) {
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        vegImage.image = UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")
        dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        ratingLabel.text = "⭐ \(menuItem.rating)"
        dishNameLabel.text = menuItem.name
        dishDescription.text = menuItem.description
        dishDeliveryExpected.text = menuItem.orderDeadline
        dishImge.image = UIImage(named: menuItem.imageURL)
        dishIntakLimit.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.KitchenMenuListaddButtonTapped(in: self)
    }
//     func applyCardStyle1() {
//            // Round the corners of the content view to make it appear as a card
//       cardViewKitchenMenu.layer.cornerRadius = 16
//        cardViewKitchenMenu.layer.masksToBounds = true
//            // Add shadow to create a card-like appearance
//        cardViewKitchenMenu.layer.shadowColor = UIColor.black.cgColor
//        cardViewKitchenMenu.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cardViewKitchenMenu.layer.shadowRadius = 5
//        cardViewKitchenMenu.layer.shadowOpacity = 0.2
//        cardViewKitchenMenu.layer.masksToBounds = false
//            // Add padding by adjusting the content insets
//        cardViewKitchenMenu.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
//            
//            // Optionally, you can add a background color for the card
//        cardViewKitchenMenu.backgroundColor = .white
//        }
}
