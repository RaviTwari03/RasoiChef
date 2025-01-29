//
//  MenuDetailsCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

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
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var mealImageView: UIImageView!
    
    @IBOutlet var availabiltyLabel: UILabel!
    
    @IBOutlet var cardViewKitchen: UIView!
    weak var delegate: MenuDetailsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCardStyle2()
//        applyCardStyle1()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.MenuListaddButtonTapped(in: self)
        
    }
    
//    var selectedItem: MenuItem?
    
    func updateMenuDetails(with indexPath: IndexPath) {
        applyCardStyle2()
        addButton.layer.cornerRadius = 11
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        mealTimeLabel.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        orderDeadlineLabel.text = "Order Before 4 pm"
        expectedDeliveryLabel.text = "Delivery Expected By 6 pm"
        mealNameLabel.text = menuItem.name
        mealPriceLabel.text = "₹\(menuItem.price)"
        mealRatingLabel.text = "⭐ \(menuItem.rating)"
        mealImageView.image = UIImage(named: menuItem.imageURL)
        availabiltyLabel.text = "\(menuItem.availability.map { $0.rawValue.capitalized }.joined(separator: ", "))"

        
    }
   
    
//    func applyCardStyle2() {
//        cardViewKitchen.layer.cornerRadius = 22
//        cardViewKitchen.layer.masksToBounds = false
//       cardViewKitchen.layer.shadowColor = UIColor.black.cgColor
//        cardViewKitchen.layer.shadowOffset = CGSize(width: 0, height: 1)
//        cardViewKitchen.layer.shadowRadius = 5
//        cardViewKitchen.layer.shadowOpacity = 0.5
//        cardViewKitchen.backgroundColor = .white
//        
// }
    
          func applyCardStyle2() {
              cardViewKitchen.layer.cornerRadius = 16
              cardViewKitchen.layer.masksToBounds = false
              cardViewKitchen.layer.shadowColor = UIColor.black.cgColor
              cardViewKitchen.layer.shadowOffset = CGSize(width: 0, height: 4)
              cardViewKitchen.layer.shadowRadius = 5
              cardViewKitchen.layer.shadowOpacity = 0.4
              cardViewKitchen.backgroundColor = .white
         }



}
