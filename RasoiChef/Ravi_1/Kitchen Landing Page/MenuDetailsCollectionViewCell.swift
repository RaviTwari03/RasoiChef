//
//  MenuDetailsCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit
//protocol MenuDetailsCollectionViewCellDelegate: AnyObject {
//    func addButtonTapped(in cell: MenuDetailsCollectionViewCell)
//}
protocol MenuDetailsCellDelegate: AnyObject {
    func MenuListaddButtonTapped(in cell: MenuDetailsCollectionViewCell)
}


class MenuDetailsCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var mealTimeLabel: UILabel!
    @IBOutlet var orderDeadlineLabel: UILabel!
    @IBOutlet var expectedDeliveryLabel: UILabel!
    
    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var mealPriceLabel: UILabel!
    @IBOutlet var mealRatingLabel: UILabel!
    
   
    @IBOutlet var mealImageView: UIImageView!
    
    @IBOutlet var availabiltyLabel: UILabel!
    weak var delegate: MenuDetailsCellDelegate?
    
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.MenuListaddButtonTapped(in: self)
    }
    
//    var selectedItem: MenuItem?
    
    func updateMenuDetails(with indexPath: IndexPath) {
        
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        mealTimeLabel.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        orderDeadlineLabel.text = "Order Before 4 pm"
        expectedDeliveryLabel.text = "Delivery Expected By 6 pm"
        mealNameLabel.text = menuItem.name
        mealPriceLabel.text = "₹\(menuItem.price)"
        mealRatingLabel.text = "⭐ \(menuItem.rating)" // Default to 0.0 if rating is nil
        mealImageView.image = UIImage(named: menuItem.imageURL)
        //        availabiltyLabel.text = .Available
        availabiltyLabel.text = "\(menuItem.availability.map { $0.rawValue.capitalized }.joined(separator: ", "))"
//        availabilityLabel.text = menuItem.availability.rawValue.capitalized
//           availabilityLabel.textColor = menuItem.availability == .Available ? .green : .gray
    }

}
