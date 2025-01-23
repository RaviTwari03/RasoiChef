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
    
    @IBOutlet var cardView: UIView!
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
    
}
