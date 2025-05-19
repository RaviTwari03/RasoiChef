//
//  SubscriptionCartItemsCollectionTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/02/25.
//

import UIKit

protocol SubscriptionCartItemTableViewCellDelegate: AnyObject {
    func SubscriptioncartdidTapRemoveButton(cell: SubscriptionCartItemsCollectionTableViewCell)
}

class SubscriptionCartItemsCollectionTableViewCell: UITableViewCell {
weak var delegate: SubscriptionCartItemTableViewCellDelegate?
    
    @IBOutlet weak var SubscriptionName1: UILabel!
    @IBOutlet weak var selectedRange1: UILabel!
    @IBOutlet weak var subscriptionPrice1: UILabel!
    @IBOutlet weak var quantityLabel1: UILabel!
    @IBOutlet weak var increaseStepper1: UIStepper!
    
    @IBOutlet var cartView: UIView!
    
    var cartItem: CartItem?  // Store reference for updates

       override func awakeFromNib() {
           super.awakeFromNib()
           
           setupCellAppearance()
           
           
          //  Configure stepper
           increaseStepper1.minimumValue = 1
           increaseStepper1.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
       }

    func configureWithSubscription(_ subscription: SubscriptionPlan) {
        SubscriptionName1.text = "Subscription Plan"
        
        // Safe unwrapping for startDate and endDate
        let startDate = subscription.startDate ?? "N/A"
        let endDate = subscription.endDate ?? "N/A"
        
        // Safe unwrapping and formatting for totalPrice
        let totalPrice = String(format: "₹%.2f", subscription.totalPrice ?? 0.0)

        selectedRange1.text = "\(startDate) - \(endDate)"
        subscriptionPrice1.text = totalPrice
        quantityLabel1.text = "1" // Default to 1 for subscription
        increaseStepper1.value = 1
    }


    @IBAction func crossButtonTapped(_ sender: Any) {
        delegate?.SubscriptioncartdidTapRemoveButton(cell: self)

    }
    
       @objc func stepperValueChanged(_ sender: UIStepper) {
           guard var cartItem = cartItem else { return }

           let newQuantity = Int(sender.value)
           quantityLabel1.text = "\(newQuantity)"
           
           // Update quantity in the cartItem model
           cartItem.quantity = newQuantity
       }
    
    
    
    
    private func setupCellAppearance() {
        // Apply corner radius
        cartView.layer.cornerRadius = 15
        cartView.layer.masksToBounds = true
            // Add shadow to create a card-like appearance
        cartView.layer.shadowColor = UIColor.black.cgColor
        cartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cartView.layer.shadowRadius = 2.5
        cartView.layer.shadowOpacity = 0.4
        cartView.layer.masksToBounds = false
            // Add padding by adjusting the content insets
        cartView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
            
            // Optionally, you can add a background color for the card
        cartView.backgroundColor = .white
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 10 // Set leading and trailing insets
        contentView.frame = contentView.frame.insetBy(dx: inset, dy: 0)
    }
    
    
    
   }
