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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization \code
        setupCellAppearance()
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

        if let menuItem = cartItem.menuItem {
            // Regular menu item
            CartDishLabel.text = menuItem.name
            CartDishDescription.text = menuItem.description
            CartDishPriceLabel.text = "₹\(menuItem.price)"
        } else if let chefSpecialtyDish = cartItem.chefSpecial {
            // Chef specialty dish
            CartDishLabel.text = chefSpecialtyDish.name
            CartDishDescription.text = chefSpecialtyDish.description
            CartDishPriceLabel.text = "₹\(chefSpecialtyDish.price)"
        } else {
            CartDishLabel.text = "Unknown Item"
            CartDishDescription.text = "No description available"
            CartDishPriceLabel.text = "₹0.0"
        }

        CartItemQuantityLabel.text = "\(cartItem.quantity)"
        CartIncreaseCounter.value = Double(cartItem.quantity)
    }
    
    
    
    private func setupCellAppearance() {
        // Apply corner radius
        cartItemView.layer.cornerRadius = 15
        cartItemView.layer.masksToBounds = true
            // Add shadow to create a card-like appearance
        cartItemView.layer.shadowColor = UIColor.black.cgColor
        cartItemView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cartItemView.layer.shadowRadius = 2.5
        cartItemView.layer.shadowOpacity = 0.4
        cartItemView.layer.masksToBounds = false
            // Add padding by adjusting the content insets
        cartItemView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
            
            // Optionally, you can add a background color for the card
        cartItemView.backgroundColor = .white
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 10 // Set leading and trailing insets
        contentView.frame = contentView.frame.insetBy(dx: inset, dy: 0)
    }
    
}




