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
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    weak var delegate: MenuDetailsCellDelegate?
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated(_:)),
            name: NSNotification.Name("CartUpdated"),
            object: nil
        )
        
        // Initial setup
        if let stepper = stepper {
            stepper.minimumValue = 0
            stepper.stepValue = 1
            stepper.layer.cornerRadius = 11
            stepperStackView.spacing = 8
        }
        
        if let stepperStackView = stepperStackView {
            stepperStackView.isHidden = true
        }
        
        if let quantityLabel = quantityLabel {
            quantityLabel.text = "0"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.MenuListaddButtonTapped(in: self)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        guard let indexPath = self.indexPath else { return }
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        
        let newQuantity = Int(sender.value)
        quantityLabel.text = "\(newQuantity)"
        
        if newQuantity == 0 {
            CartViewController.cartItems.removeAll { $0.menuItem?.itemID == menuItem.itemID }
            stepperStackView.isHidden = true
            addButton.isHidden = false
        } else {
            if let existingItemIndex = CartViewController.cartItems.firstIndex(where: { $0.menuItem?.itemID == menuItem.itemID }) {
                CartViewController.cartItems[existingItemIndex].quantity = newQuantity
            }
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": menuItem.itemID,
                "quantity": newQuantity,
                "isChefSpecial": false
            ]
        )
    }
    
    func updateMenuDetails(with indexPath: IndexPath) {
        self.indexPath = indexPath
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        
        // Update basic details
        mealTimeLabel.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
        orderDeadlineLabel.text = menuItem.orderDeadline
        expectedDeliveryLabel.text = menuItem.recievingDeadline
        mealNameLabel.text = menuItem.name
        mealPriceLabel.text = "₹\(menuItem.price)"
        mealRatingLabel.text = "\(menuItem.rating)"
        mealImageView.image = UIImage(named: menuItem.imageURL)
        
        // Check cart state
        let cartQuantity = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        // Update UI based on cart state
        if cartQuantity > 0 {
            stepperStackView.isHidden = false
            addButton.isHidden = true
            stepper.value = Double(cartQuantity)
            quantityLabel.text = "\(cartQuantity)"
        } else {
            stepperStackView.isHidden = true
            addButton.isHidden = false
            stepper.value = 0
            quantityLabel.text = "0"
        }
        
        applyCardStyle1()
    }
    
    @objc private func cartUpdated(_ notification: Notification) {
        guard let indexPath = self.indexPath,
              let userInfo = notification.userInfo,
              let menuItemID = userInfo["menuItemID"] as? String else {
            return
        }
        
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        if menuItem.itemID == menuItemID {
            updateMenuDetails(with: indexPath)
        }
    }
    
    func applyCardStyle1() {
        cardViewKitchen.layer.cornerRadius = 15
        cardViewKitchen.layer.masksToBounds = false
        cardViewKitchen.layer.shadowColor = UIColor.black.cgColor
        cardViewKitchen.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardViewKitchen.layer.shadowRadius = 2.5
        cardViewKitchen.layer.shadowOpacity = 0.4
        cardViewKitchen.backgroundColor = .white
   }



}
//extension MenuDetailsCollectionViewCell: AddItemDelegate {
//    func didAddItemToCart(_ item: CartItem, quantity: Int) {
//        self.addedItemCount += quantity // Update item count
//    }
//}
