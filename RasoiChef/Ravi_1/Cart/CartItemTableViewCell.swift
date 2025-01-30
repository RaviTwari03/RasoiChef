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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization \code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func crossButtonTapped(_ sender: UIButton) {
           delegate?.didTapRemoveButton(cell: self)
       }
    
    @IBAction func CartIncreaseCounter(_ sender: UIStepper) {
        CartItemQuantityLabel.text = "\(Int(sender.value))"
        let newQuantity = Int(sender.value)

           if newQuantity > 10 {
               // Reset stepper value to 10
               sender.value = 10

               // Show an alert
               if let parentViewController = self.window?.rootViewController {
                   let alert = UIAlertController(
                       title: "Limit Exceeded",
                       message: "You can only add up to 10 items.",
                       preferredStyle: .alert
                   )
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   parentViewController.present(alert, animated: true, completion: nil)
               }

               return
           }
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
    func configure(with item: CartItem) {
        CartDishLabel.text = item.menuItem.name
        CartDishDescription.text = item.menuItem.description
        CartDishPriceLabel.text = "₹\(item.menuItem.price)"
        CartItemQuantityLabel.text = "Qty: \(item.quantity)"
      }
    }




