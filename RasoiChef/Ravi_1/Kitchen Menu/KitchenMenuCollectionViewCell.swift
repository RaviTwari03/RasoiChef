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
    
    @IBOutlet var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        applyCardStyle1()
//        applyCardStyle1()
    }
    weak var delegate: KitchenMenuDetailsCellDelegate?
    
    func updateMealDetails(with indexPath: IndexPath) {
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        vegImage.image = UIImage(named: "vegImage")
        dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        ratingLabel.text = "⭐ \(menuItem.rating)"
        dishNameLabel.text = menuItem.name
        dishDescription.text = menuItem.description
        dishDeliveryExpected.text = menuItem.orderDeadline
        dishImge.image = UIImage(named: menuItem.imageURL)
        dishIntakLimit.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
       applyCardStyle1()
        addButton.layer.cornerRadius = 11
    }
   
         func applyCardStyle1() {
            cardViewKitchenMenu.layer.cornerRadius = 16
            cardViewKitchenMenu.layer.masksToBounds = false
            cardViewKitchenMenu.layer.shadowColor = UIColor.black.cgColor
            cardViewKitchenMenu.layer.shadowOffset = CGSize(width: 0, height: 4)
            cardViewKitchenMenu.layer.shadowRadius = 5
            cardViewKitchenMenu.layer.shadowOpacity = 0.4
            cardViewKitchenMenu.backgroundColor = .white
        }
   
        
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.KitchenMenuListaddButtonTapped(in: self)
    }

}
