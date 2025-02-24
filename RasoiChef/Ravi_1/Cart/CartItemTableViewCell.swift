//
//  CartItemTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit
protocol CartItemTableViewCellDelegate: AnyObject {
    func didTapRemoveButton(cell: CartItemTableViewCell)
}

class CartItemTableViewCell: UITableViewCell {

    weak var delegate: CartItemTableViewCellDelegate?
    
    @IBOutlet var CartDishLabel: UILabel!
    @IBOutlet var CartDishDescription: UILabel!
    @IBOutlet var CartDishPriceLabel: UILabel!
    @IBOutlet var CartItemQuantityLabel: UILabel!
    @IBOutlet var CartIncreaseCounter: UIStepper!
    @IBOutlet var crossbutton: UIButton!
    
    @IBOutlet weak var cartItemView: UIView!
 
    var indexPath: IndexPath?
    var cartItem: CartItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
        
        // Add observer for cart updates with userInfo
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated(_:)),
            name: NSNotification.Name("CartUpdated"),
            object: nil
        )
    }
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        delegate?.didTapRemoveButton(cell: self)
    }

    @IBAction func CartIncreaseCounter(_ sender: UIStepper) {
        guard let indexPath = indexPath else { return }
        
        let newQuantity = Int(sender.value)
        
        // Ensure quantity is at least 1
        let finalQuantity = max(newQuantity, 1)
        
        // Update both the data source and the local reference
        if indexPath.row < CartViewController.cartItems.count {
            CartViewController.cartItems[indexPath.row].quantity = finalQuantity
            self.cartItem = CartViewController.cartItems[indexPath.row]
        }
        
        // Update the UI
        CartItemQuantityLabel.text = "\(finalQuantity)"
        
        // Update price and send notification based on item type
        if let menuItem = cartItem?.menuItem {
            let totalPrice = menuItem.price * Double(finalQuantity)
            CartDishPriceLabel.text = "₹\(totalPrice)"
            
            NotificationCenter.default.post(
                name: NSNotification.Name("CartUpdated"),
                object: nil,
                userInfo: [
                    "menuItemID": menuItem.itemID,
                    "quantity": finalQuantity,
                    "isChefSpecial": false
                ]
            )
        } else if let chefSpecial = cartItem?.chefSpecial {
            let totalPrice = chefSpecial.price * Double(finalQuantity)
            CartDishPriceLabel.text = "₹\(totalPrice)"
            
            NotificationCenter.default.post(
                name: NSNotification.Name("CartUpdated"),
                object: nil,
                userInfo: [
                    "menuItemID": chefSpecial.dishID,
                    "quantity": finalQuantity,
                    "isChefSpecial": true
                ]
            )
        }
        
        // Reload cart to update total
        if let parentVC = self.parentViewController as? CartViewController {
            parentVC.reloadCart()
        }
    }

    func updateCartItem(for indexPath: IndexPath) {
        self.indexPath = indexPath
        
        guard indexPath.row < CartViewController.cartItems.count else {
            print("Index out of range: \(indexPath.row) exceeds number of cart items")
            return
        }
        
        // Store reference to cart item
        self.cartItem = CartViewController.cartItems[indexPath.row]
        
        if let menuItem = cartItem?.menuItem {
            CartDishLabel.text = menuItem.name
            CartDishDescription.text = menuItem.description
            let totalPrice = menuItem.price * Double(cartItem?.quantity ?? 0)
            CartDishPriceLabel.text = "₹\(totalPrice)"
            
            // Set stepper values with minimum 1
            CartIncreaseCounter.minimumValue = 1.0
            CartIncreaseCounter.maximumValue = Double(menuItem.intakeLimit)
            CartIncreaseCounter.value = Double(cartItem?.quantity ?? 1)
            CartItemQuantityLabel.text = "\(cartItem?.quantity ?? 1)"
        } else if let chefSpecial = cartItem?.chefSpecial {
            CartDishLabel.text = chefSpecial.name
            CartDishDescription.text = chefSpecial.description
            let totalPrice = chefSpecial.price * Double(cartItem?.quantity ?? 0)
            CartDishPriceLabel.text = "₹\(totalPrice)"
            
            // Set stepper values with minimum 1
            CartIncreaseCounter.minimumValue = 1.0
            CartIncreaseCounter.maximumValue = Double(chefSpecial.intakeLimit)
            CartIncreaseCounter.value = Double(cartItem?.quantity ?? 1)
            CartItemQuantityLabel.text = "\(cartItem?.quantity ?? 1)"
        }
    }

    private func setupCellAppearance() {
        cartItemView.layer.cornerRadius = 15
        cartItemView.layer.masksToBounds = true
        cartItemView.layer.shadowColor = UIColor.black.cgColor
        cartItemView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cartItemView.layer.shadowRadius = 2.5
        cartItemView.layer.shadowOpacity = 0.4
        cartItemView.layer.masksToBounds = false
        cartItemView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        cartItemView.backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 10
        contentView.frame = contentView.frame.insetBy(dx: inset, dy: 0)
    }

    // Add this method to handle cart updates
    @objc private func cartUpdated(_ notification: Notification) {
        guard let cartItem = self.cartItem,
              let userInfo = notification.userInfo,
              let updatedItemID = userInfo["menuItemID"] as? String,
              let updatedQuantity = userInfo["quantity"] as? Int,
              cartItem.menuItem?.itemID == updatedItemID else {
            return
        }
        
        // Update the UI
        CartItemQuantityLabel.text = "\(updatedQuantity)"
        CartIncreaseCounter.value = Double(updatedQuantity)
        
        // Update price
        if let menuItem = cartItem.menuItem {
            let totalPrice = menuItem.price * Double(updatedQuantity)
            CartDishPriceLabel.text = "₹\(totalPrice)"
        }
    }

    // Add deinit to remove observer when cell is deallocated
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func configure(with cartItem: CartItem) {
        self.cartItem = cartItem
        CartItemQuantityLabel.text = "\(cartItem.quantity)"
        
        // Fix the price calculation
        if let price = cartItem.menuItem?.price {
            let totalPrice = price * Double(cartItem.quantity)
            CartDishPriceLabel.text = "₹\(totalPrice)"
        }
    }
}
