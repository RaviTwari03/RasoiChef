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
    
//    func updateMealDetails(with indexPath: IndexPath) {
//        let menuItem = KitchenDataController.menuItems[indexPath.row]
//        vegImage.image = UIImage(named: "vegImage")
////        dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
//        ratingLabel.text = "⭐ \(menuItem.rating)"
//        dishNameLabel.text = menuItem.name
//        dishDescription.text = menuItem.description
//        dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
//        dishDeliveryExpected.text = menuItem.orderDeadline
//        dishImge.image = UIImage(named: menuItem.imageURL ?? "")
//        dishprice.text = "₹\(menuItem.price)"
//
//        dishIntakLimit.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
//       applyCardStyle1()
//        addButton.layer.cornerRadius = 11
//    }
//
    func updateMealDetails(with indexPath: IndexPath) {
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        vegImage.image = UIImage(named: "vegImage")
        ratingLabel.text = "⭐ \(menuItem.rating)"
        dishNameLabel.text = menuItem.name
        
        let words = menuItem.description.split(separator: " ")
        if words.count > 9 {
            let truncatedText = words.prefix(9).joined(separator: " ") + "...read more"
            let attributedString = NSMutableAttributedString(string: truncatedText)
            let readMoreRange = (truncatedText as NSString).range(of: "...read more")
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: readMoreRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readMoreRange)
            
            dishDescription.attributedText = attributedString
            dishDescription.isUserInteractionEnabled = false
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(readMoreTapped))
            dishDescription.addGestureRecognizer(tapGesture)
        } else {
            dishDescription.text = menuItem.description
        }

        dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        dishDeliveryExpected.text = menuItem.orderDeadline
        dishImge.image = UIImage(named: menuItem.imageURL ?? "")
        dishprice.text = "₹\(menuItem.price)"
        dishIntakLimit.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"

        applyCardStyle1()
        addButton.layer.cornerRadius = 11
    }

    @objc func readMoreTapped() {
        dishDescription.text = KitchenDataController.menuItems.first(where: { $0.name == dishNameLabel.text })?.description
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
