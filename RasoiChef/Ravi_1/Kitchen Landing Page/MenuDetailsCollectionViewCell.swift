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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOrderPlacement),
            name: NSNotification.Name("OrderPlaced"),
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
        
        // Animate quantity label update
        UIView.transition(with: quantityLabel, duration: 0.2, options: .transitionCrossDissolve) {
            self.quantityLabel.text = "\(newQuantity)"
        }
        
        if newQuantity == 0 {
            // Animate visibility changes
            UIView.animate(withDuration: 0.3) {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
            }
            CartViewController.cartItems.removeAll { $0.menuItem?.itemID == menuItem.itemID }
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
        
        // Update meal type and timing details
        if let firstMealType = menuItem.availableMealTypes.first {
            mealTimeLabel.text = firstMealType.rawValue.capitalized
        }
        
        // Update order deadline and delivery time
        orderDeadlineLabel.text = "Order Before \(menuItem.orderDeadline)"
        if let receivingTime = menuItem.recievingDeadline {
            expectedDeliveryLabel.text = "Delivery Expected by \(receivingTime)"
        }
        
        // Update meal name and price
        mealNameLabel.text = menuItem.name
        mealPriceLabel.text = "₹\(menuItem.price)"
        
        // Update rating
        mealRatingLabel.text = String(format: "%.1f", menuItem.rating)
        
        // Update meal image
        if !menuItem.imageURL.isEmpty {
            mealImageView.image = UIImage(named: menuItem.imageURL)
        }
        
        // Update availability status
        if menuItem.intakeLimit > 0 {
            availabiltyLabel.text = "Available (\(menuItem.intakeLimit) left)"
            availabiltyLabel.textColor = .systemGreen
        } else {
            availabiltyLabel.text = "Unavailable"
            availabiltyLabel.textColor = .systemRed
        }
        
        updateCartState(for: menuItem)
        applyCardStyle1()
    }
    
    private func updateCartState(for menuItem: MenuItem) {
        // Calculate quantities
        let cartQuantity = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        let totalOrderedQuantity = cartQuantity + placedOrdersQuantity
        let remainingIntake = menuItem.intakeLimit - totalOrderedQuantity
        
        // Update availability UI
        UIView.animate(withDuration: 0.3) {
            if remainingIntake > 0 {
                self.availabiltyLabel.text = "Available (\(remainingIntake) left)"
                self.availabiltyLabel.textColor = UIColor.systemGreen
                self.addButton.isEnabled = true
                self.addButton.alpha = 1.0
            } else {
                self.availabiltyLabel.text = "Unavailable"
                self.availabiltyLabel.textColor = UIColor.systemRed
                self.addButton.isEnabled = false
                self.addButton.alpha = 0.5
            }
            
            // Update cart state UI
            if cartQuantity > 0 {
                self.stepperStackView.isHidden = false
                self.addButton.isHidden = true
                self.stepper.value = Double(cartQuantity)
                self.quantityLabel.text = "\(cartQuantity)"
                self.stepper.maximumValue = Double(remainingIntake + cartQuantity)
            } else {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
                self.stepper.value = 0
                self.quantityLabel.text = "0"
            }
        }
    }
    
    @objc private func cartUpdated(_ notification: Notification) {
        guard let indexPath = self.indexPath,
              let userInfo = notification.userInfo,
              let menuItemID = userInfo["menuItemID"] as? String else {
            return
        }
        
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        if menuItem.itemID == menuItemID {
            // Animate the update
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                self.updateCartState(for: menuItem)
            }
        }
    }
    
    @objc private func handleOrderPlacement() {
        // Hide stepper and show add button when order is placed
        stepperStackView.isHidden = true
        addButton.isHidden = false
        addButton.isEnabled = true
        addButton.alpha = 1.0
    }
    
    func applyCardStyle1() {
        cardViewKitchen.layer.cornerRadius = 15
        cardViewKitchen.layer.masksToBounds = false
        cardViewKitchen.layer.shadowColor = UIColor.black.cgColor
        cardViewKitchen.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardViewKitchen.layer.shadowRadius = 2.5
        cardViewKitchen.layer.shadowOpacity = 0.2
        cardViewKitchen.backgroundColor = .white
    }

    func updateIntakeLimit(for indexPath: IndexPath) {
        self.indexPath = indexPath
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        
        // Calculate total ordered quantity
        let cartQuantity = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        let totalOrderedQuantity = cartQuantity + placedOrdersQuantity
        let remainingIntake = menuItem.intakeLimit - totalOrderedQuantity
        
        // Update UI
        if remainingIntake > 0 {
            availabiltyLabel.text = "Available (\(remainingIntake) left)"
            availabiltyLabel.textColor = UIColor.systemGreen
            addButton.isEnabled = true
            addButton.alpha = 1.0
        } else {
            availabiltyLabel.text = "Unavailable"
            availabiltyLabel.textColor = UIColor.systemRed
            addButton.isEnabled = false
            addButton.alpha = 0.5
        }
        
        // Update stepper
        stepper.maximumValue = Double(remainingIntake + cartQuantity)
        stepper.value = Double(cartQuantity)
        quantityLabel.text = "\(cartQuantity)"
        
        // Update visibility
        stepperStackView.isHidden = cartQuantity == 0
        addButton.isHidden = cartQuantity > 0
    }
}
//extension MenuDetailsCollectionViewCell: AddItemDelegate {
//    func didAddItemToCart(_ item: CartItem, quantity: Int) {
//        self.addedItemCount += quantity // Update item count
//    }
//}
