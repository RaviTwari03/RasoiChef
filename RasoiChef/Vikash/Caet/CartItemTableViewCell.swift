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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    let cartItem = KitchenDataController.cartItems
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    static var totalCartItems: Int {
//        return cartItem.count
//    }
//
//    static func addItemToCart(_ item: CartItem) {
//        cartItem.append(item)
//    }
//
//    static func removeItemFromCart(at index: Int) {
//        guard index < cartItem.count else { return }
//        cartItem.remove(at: index)
//    }
//
//    static func clearCart() {
//        cartItem.removeAll()
//    }

    
//    func updateCartItem(for indexpathe : IndexPath) {
       
//            CartDishLabel.text = cartItem.menuItem.name
//            CartDishDescription.text = cartItem.menuItem.description
//            CartDishPriceLabel.text = "₹\(cartItem.menuItem.price)"
//            CartItemQuantityLabel.text = "\(cartItem.quantity)"
//            CartIncreaseCounter.value = Double(cartItem.quantity)
//        }
//    
    }




