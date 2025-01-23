//
//  CartItemTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    
    @IBOutlet var CartDishLabel: UILabel!
    @IBOutlet var CartDishDescription: UILabel!
    @IBOutlet var CartDishPriceLabel: UILabel!
    @IBOutlet var CartItemQuantityLabel: UILabel!
    @IBOutlet var CartIncreaseCounter: UIStepper!
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    
//    func updateCartItem(for indexpath: IndexPath) {
//        if KitchenDataController.cartItems.isEmpty {
//            print("The cart is empty, no items to update.")
//            return
//        }
//        
//        guard indexpath.row < KitchenDataController.cartItems.count else {
//            print("Index out of range: \(indexpath.row) exceeds number of cart items")
//            return
//        }
//        
//        let cartItem = KitchenDataController.cartItems[indexpath.row]
//        CartDishLabel.text = cartItem.menuItem.name
//        CartDishDescription.text = cartItem.menuItem.description
//        CartDishPriceLabel.text = "₹\(cartItem.menuItem.price)"
//        CartItemQuantityLabel.text = "\(cartItem.quantity)"
//        CartIncreaseCounter.value = Double(cartItem.quantity)
//    }
    var onQuantityChanged: ((Int) -> Void)? // Closure to notify quantity changes
        
        override func awakeFromNib() {
            super.awakeFromNib()
            CartIncreaseCounter.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

        func updateCartItem(for indexpath: IndexPath) {
            if KitchenDataController.cartItems.isEmpty {
                print("The cart is empty, no items to update.")
                return
            }
            
            guard indexpath.row < KitchenDataController.cartItems.count else {
                print("Index out of range: \(indexpath.row) exceeds number of cart items")
                return
            }
            
            let cartItem = KitchenDataController.cartItems[indexpath.row]
            CartDishLabel.text = cartItem.menuItem.name
            CartDishDescription.text = cartItem.menuItem.description
            CartDishPriceLabel.text = "₹\(cartItem.menuItem.price)"
            CartItemQuantityLabel.text = "\(cartItem.quantity)"
            CartIncreaseCounter.value = Double(cartItem.quantity)
        }

        @objc func stepperValueChanged(_ sender: UIStepper) {
            let updatedQuantity = Int(sender.value)
            CartItemQuantityLabel.text = "\(updatedQuantity)"
            onQuantityChanged?(updatedQuantity) // Notify the quantity change
        }
    }
    




