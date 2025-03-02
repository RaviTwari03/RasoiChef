//
//  MenuCategoriesCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit

class MenuCategoriesCollectionViewCell: UICollectionViewCell {
        
    var mealTiming:MealTiming = .breakfast
    
    weak var delegate: MealCategoriesCollectionViewCellDelegate?

    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var orderIntakeLimitLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var KitchenDistance: UILabel!
    
    @IBOutlet weak var Ratings: UILabel!
    
    @IBOutlet weak var vegNonVegIcon: UIImageView!
    
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    
    var menuItem: MenuItem?

    override func awakeFromNib() {
            super.awakeFromNib()
            stepperStackView.isHidden = true  // Hide stepper initially
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(cartUpdated),
                name: NSNotification.Name("CartUpdated"),
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateCellUI),
                name: NSNotification.Name("UpdateMenuCategoryCell"),
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleOrderPlacement),
                name: NSNotification.Name("OrderPlaced"),
                object: nil
            )

        


            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        }
    
    
    func updateMealDetails(with menuItem: MenuItem) {
        self.menuItem = menuItem
        mealNameLabel.text = menuItem.name
        mealImage.image = UIImage(named: menuItem.imageURL ?? "")
        kitchenNameLabel.text = menuItem.kitchenName
        KitchenDistance.text = "\(menuItem.distance) km"
        Ratings.text = "\(menuItem.rating)"
        priceLabel.text = "₹\(menuItem.price)"
        descriptionLabel.text = menuItem.description

        if menuItem.mealCategory.contains(.veg) {
            vegNonVegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonVegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
        
        updateCartAndIntakeState()
    }

    private func updateCartAndIntakeState() {
        guard let item = menuItem else { return }
        
        // Calculate total quantity in cart
        let cartQuantity = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == item.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        // Calculate total quantity in placed orders
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.menuItem?.itemID == item.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        // Calculate remaining intake
        let remainingIntake = item.intakeLimit - (cartQuantity + placedOrdersQuantity)
        
        // Update intake limit label
        orderIntakeLimitLabel.text = "Remaining intake: \(remainingIntake)"
        
        // Update stepper configuration
        stepper.maximumValue = Double(remainingIntake + cartQuantity) // Allow current cart quantity plus remaining
        stepper.minimumValue = 0
        stepper.value = Double(cartQuantity)
        quantityLabel.text = "\(cartQuantity)"
        
        // Update visibility
        if remainingIntake <= 0 && cartQuantity == 0 {
            // No remaining intake and not in cart
            stepperStackView.isHidden = true
            addButton.isHidden = false
            addButton.isEnabled = false
            addButton.alpha = 0.5
        } else if cartQuantity > 0 {
            // Item is in cart
            stepperStackView.isHidden = false
            addButton.isHidden = true
            stepper.isEnabled = remainingIntake > 0
        } else {
            // Item can be added
            stepperStackView.isHidden = true
            addButton.isHidden = false
            addButton.isEnabled = true
            addButton.alpha = 1.0
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        guard let menuItem = menuItem else { return }
        
        // Just call the delegate to show the modal
        delegate?.MealcategoriesButtonTapped(in: self)
    }

    @objc func stepperValueChanged(_ sender: UIStepper) {
        guard let menuItem = menuItem else { return }
        
        let newQuantity = Int(sender.value)
        
        // Calculate placed orders quantity
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        // Get current cart quantity
        let currentCartQuantity = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        // Always allow decreasing quantity
        if newQuantity < currentCartQuantity {
            updateCart(with: newQuantity)
            return
        }
        
        // Check intake limit only when increasing quantity
        let totalQuantity = newQuantity + placedOrdersQuantity
        if totalQuantity <= menuItem.intakeLimit {
            updateCart(with: newQuantity)
        } else {
            // Reset to current quantity and show alert
            sender.value = Double(currentCartQuantity)
            quantityLabel.text = "\(currentCartQuantity)"
            
            if let parentViewController = self.next?.next as? UIViewController {
                let alert = UIAlertController(
                    title: "Intake Limit Reached",
                    message: "You have reached the maximum intake limit for this item.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                parentViewController.present(alert, animated: true)
            }
        }
    }

    private func updateCart(with quantity: Int) {
        guard let menuItem = menuItem else { return }
        
        // Remove existing item from cart
        CartViewController.cartItems.removeAll { $0.menuItem?.itemID == menuItem.itemID }
        
        if quantity > 0 {
            // Add new item to cart
            let cartItem = CartItem(
                userAdress: "Galgotias University",
                quantity: quantity,
                menuItem: menuItem,
                subscriptionDetails: nil
            )
            CartViewController.cartItems.append(cartItem)
            
            // Update UI
            quantityLabel.text = "\(quantity)"
            stepperStackView.isHidden = false
            addButton.isHidden = true
        } else {
            // Reset UI for zero quantity
            stepperStackView.isHidden = true
            addButton.isHidden = false
            addButton.isEnabled = true
            addButton.alpha = 1.0
        }
        
        // Update cart badge
        updateCartBadge()
        
        // Notify cart update
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": menuItem.itemID,
                "quantity": quantity,
                "isChefSpecial": false
            ]
        )
    }

    private func updateCartBadge() {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
           let tabItems = tabBarController.tabBar.items {
            let cartTabItem = tabItems[2] // Cart tab is at index 2
            let itemCount = CartViewController.cartItems.count // Count number of items instead of quantities
            cartTabItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
        }
    }

    @objc private func cartUpdated() {
        updateCartAndIntakeState()
    }

    @objc private func updateCellUI() {
        updateCartAndIntakeState()
    }

    @objc private func handleOrderPlacement() {
        updateCartAndIntakeState()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
