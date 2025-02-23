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
    
    var isExpanded: Bool = false

    
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
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
       
    
    weak var delegate: KitchenMenuDetailsCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: NSNotification.Name("CartUpdated"), object: nil)
    }

    @objc func cartUpdated() {
        if let collectionView = self.superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self) {
            updateIntakeLimit(for: indexPath)
        }
    }

    func updateMealDetails(with indexPath: IndexPath) {
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        vegImage.image = UIImage(named: "vegImage")
        ratingLabel.text = "\(menuItem.rating)"
        dishNameLabel.text = menuItem.name
        updateIntakeLimit(for: indexPath)

        let words = menuItem.description.split(separator: " ")
        if words.count > 9 {
            let truncatedText = words.prefix(9).joined(separator: " ") + "...read more"
            let attributedString = NSMutableAttributedString(string: truncatedText)
            let readMoreRange = (truncatedText as NSString).range(of: "...read more")
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: readMoreRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readMoreRange)
            
            dishDescription.attributedText = attributedString
            dishDescription.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(readMoreTapped))
            dishDescription.addGestureRecognizer(tapGesture)
        } else {
            dishDescription.text = menuItem.description
        }

        dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        dishDeliveryExpected.text = menuItem.orderDeadline
        dishImge.image = UIImage(named: menuItem.imageURL)
        dishprice.text = "₹\(menuItem.price)"
        dishIntakLimit.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
        
        if menuItem.mealCategory.contains(.veg) {
            vegImage.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegImage.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }

        applyCardStyle1()
    }


         func applyCardStyle1() {
            cardViewKitchenMenu.layer.cornerRadius = 15
            cardViewKitchenMenu.layer.masksToBounds = false
            cardViewKitchenMenu.layer.shadowColor = UIColor.black.cgColor
            cardViewKitchenMenu.layer.shadowOffset = CGSize(width: 0, height: 2)
             cardViewKitchenMenu.layer.shadowRadius = 2.5
            cardViewKitchenMenu.layer.shadowOpacity = 0.4
            cardViewKitchenMenu.backgroundColor = .white
        }
   
        
    @IBAction func addButtonTapped(_ sender: Any) {
        
        //        delegate?.KitchenMenuListaddButtonTapped(in: self)
        delegate?.KitchenMenuListaddButtonTapped(in: self)
        
        // Update the intake limit dynamically
        if let collectionView = self.superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self) {
            updateIntakeLimit(for: indexPath)
        }
    }
    @objc func readMoreTapped() {
        isExpanded.toggle() // Toggle the state

        let fullText = KitchenDataController.menuItems.first(where: { $0.name == dishNameLabel.text })?.description ?? ""
        dishDescription.text = isExpanded ? fullText : fullText.split(separator: " ").prefix(9).joined(separator: " ") + "...read more"
        
        UIView.animate(withDuration: 0.3) {
            self.superview?.superview?.layoutIfNeeded() // Ensures layout updates smoothly
        }
        
        // Notify the collection view to update the cell size
        if let collectionView = self.superview as? UICollectionView {
            if collectionView.indexPath(for: self) != nil {
                collectionView.performBatchUpdates(nil, completion: nil)
            }
        }
    }
    func updateIntakeLimit(for indexPath: IndexPath) {
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        let orderedQuantity = CartViewController.cartItems.filter { $0.menuItem?.itemID == menuItem.itemID }.reduce(0) { $0 + $1.quantity }
        
        let remainingIntake = max(menuItem.intakeLimit - orderedQuantity, 0) // Ensure it doesn't go below 0
        dishIntakLimit.text = "Intake limit: \(remainingIntake)"
        
        // Disable add button if intake limit is reached
        addButton.isEnabled = remainingIntake > 0
        addButton.alpha = remainingIntake > 0 ? 1.0 : 0.5
    }

}
