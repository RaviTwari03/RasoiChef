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

        override func awakeFromNib() {
            super.awakeFromNib()
            setupCellAppearance()
        }
        
        @IBAction func crossButtonTapped(_ sender: UIButton) {
            delegate?.didTapRemoveButton(cell: self)
        }

        @IBAction func CartIncreaseCounter(_ sender: UIStepper) {
            guard let indexPath = indexPath else { return }
            guard indexPath.row < KitchenDataController.cartItems.count else { return }

            var cartItem = KitchenDataController.cartItems[indexPath.row]

            let newQuantity = Int(sender.value)
            var remainingLimit = Int.max  // Default to no limit

            if let menuItem = cartItem.menuItem {
                // ✅ Check intake limit for normal menu items
                let totalOrdered = KitchenDataController.cartItems
                    .filter { $0.menuItem?.itemID == menuItem.itemID }
                    .reduce(0) { $0 + $1.quantity }

                remainingLimit = menuItem.intakeLimit - (totalOrdered - cartItem.quantity)
                
            } else if let chefSpecial = cartItem.chefSpecial {
                // ✅ Check intake limit for chef specialty dishes
                let totalOrdered = KitchenDataController.cartItems
                    .filter { $0.chefSpecial?.dishID == chefSpecial.dishID }
                    .reduce(0) { $0 + $1.quantity }

                remainingLimit = chefSpecial.intakeLimit - (totalOrdered - cartItem.quantity)
            }

            if newQuantity > remainingLimit {
                sender.value = Double(cartItem.quantity) // Reset to previous valid value
                showAlert(message: "You can only add up to \(remainingLimit) more of this item.")
                return
            }

            // ✅ Update the item in KitchenDataController
            KitchenDataController.cartItems[indexPath.row].quantity = newQuantity
            updateCartQuantity(newQuantity)
        }

        func updateCartItem(for indexPath: IndexPath) {
            self.indexPath = indexPath

            guard indexPath.row < KitchenDataController.cartItems.count else {
                print("Index out of range: \(indexPath.row) exceeds number of cart items")
                return
            }

            let cartItem = KitchenDataController.cartItems[indexPath.row]

            if let menuItem = cartItem.menuItem {
                CartDishLabel.text = menuItem.name
                CartDishDescription.text = menuItem.description
                CartDishPriceLabel.text = "₹\(menuItem.price)"
            } else if let chefSpecial = cartItem.chefSpecial {
                CartDishLabel.text = chefSpecial.name
                CartDishDescription.text = chefSpecial.description
                CartDishPriceLabel.text = "₹\(chefSpecial.price)"
            } else {
                CartDishLabel.text = "Unknown Item"
                CartDishDescription.text = "No description available"
                CartDishPriceLabel.text = "₹0.0"
            }

            CartIncreaseCounter.minimumValue = 1
            CartIncreaseCounter.value = Double(cartItem.quantity)
            CartItemQuantityLabel.text = "\(cartItem.quantity)"
        }

        private func updateCartQuantity(_ newQuantity: Int) {
            CartItemQuantityLabel.text = "\(newQuantity)"
            CartIncreaseCounter.value = Double(newQuantity)

            if let parentVC = self.parentViewController as? CartViewController {
                parentVC.reloadCart()
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

        private func showAlert(message: String) {
            if let viewController = self.parentViewController {
                let alert = UIAlertController(title: "Limit Exceeded", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                viewController.present(alert, animated: true)
            }
        }
    }
