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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCartItem(for indexpathe : IndexPath) {
        let cartItem = KitchenDataController.cartItems[indexpathe.row]
            CartDishLabel.text = cartItem.menuItem.name
            CartDishDescription.text = cartItem.menuItem.description
            CartDishPriceLabel.text = "₹\(cartItem.menuItem.price)"
            CartItemQuantityLabel.text = "\(cartItem.quantity)"
            CartIncreaseCounter.value = Double(cartItem.quantity)
        }
    
    }




