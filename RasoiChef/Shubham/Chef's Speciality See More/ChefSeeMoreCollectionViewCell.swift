//
//  ChefSeeMoreCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 23/01/25.
//

import UIKit

protocol ChefSpecialMenuSeeMoreDetailsCellDelegate: AnyObject {
    func ChefSpecialaddButtonTapped(in cell: ChefSeeMoreCollectionViewCell)
}


class ChefSeeMoreCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : ChefSpecialMenuSeeMoreDetailsCellDelegate?
    
    
    @IBOutlet var DishImage: UIImageView!
    @IBOutlet var dishName: UILabel!
    @IBOutlet var PriceOfDish: UILabel!
    @IBOutlet var kitchenName: UILabel!
    @IBOutlet var Ratings: UILabel!
    @IBOutlet var Distance: UILabel!
    
    @IBOutlet weak var vegNonvegIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepperStackView: UIStackView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    private var currentDish: ChefSpecialtyDish?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initial setup
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.layer.cornerRadius = 11
        stepperStackView.spacing = 8
        stepperStackView.isHidden = true
        quantityLabel.text = "0"
        
        // Add observers
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
        
        // Add stepper target
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateSpecialDishDetails(with specialDish: ChefSpecialtyDish) {
        currentDish = specialDish
        dishName.text = specialDish.name
        PriceOfDish.text = "₹\(specialDish.price)"
        kitchenName.text = specialDish.kitchenName
        Ratings.text = "\(specialDish.rating)"
        Distance.text = "\(specialDish.distance) km"
        
        // Load image from URL
        if let imageURL = URL(string: specialDish.imageURL) {
            loadImage(from: imageURL)
        } else {
            DishImage.image = UIImage(systemName: "photo") // Fallback image
        }

        // Set veg/non-veg icon
        if specialDish.mealCategory.contains(.veg) {
            print("Debug - Setting veg icon for dish:", specialDish.name)
            if let vegIcon = UIImage(named: "vegIcon") {
                vegNonvegIcon.image = vegIcon
            } else {
                vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            }
        } else {
            print("Debug - Setting non-veg icon for dish:", specialDish.name)
            if let nonVegIcon = UIImage(named: "nonVegIcon") {
                vegNonvegIcon.image = nonVegIcon
            } else {
                vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            }
        }
        
        // Update intake limit and UI state
        updateIntakeLimit()
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.DishImage.image = UIImage(systemName: "photo") // Fallback image
                }
                return
            }
            
            DispatchQueue.main.async {
                self.DishImage.image = image
            }
        }.resume()
    }

    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let dish = currentDish else { return }
        // Just call the delegate to show the modal
        delegate?.ChefSpecialaddButtonTapped(in: self)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        guard let dish = currentDish else { return }
        
        let newQuantity = Int(sender.value)
        
        // Calculate total ordered quantity
        let cartQuantity = CartViewController.cartItems
            .filter { $0.chefSpecial?.dishID == dish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.chefSpecial?.dishID == dish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let totalWithNewQuantity = placedOrdersQuantity + newQuantity
        
        // Check if exceeding limit
        if totalWithNewQuantity > dish.intakeLimit {
            sender.value = Double(newQuantity - 1)
            quantityLabel.text = "\(newQuantity - 1)"
            return
        }
        
        // Update quantity label
        UIView.transition(with: quantityLabel, duration: 0.2, options: .transitionCrossDissolve) {
            self.quantityLabel.text = "\(newQuantity)"
        }
        
        // Handle cart updates
        if newQuantity == 0 {
            UIView.animate(withDuration: 0.3) {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
            }
            CartViewController.cartItems.removeAll { $0.chefSpecial?.dishID == dish.dishID }
        } else {
            if let existingItemIndex = CartViewController.cartItems.firstIndex(where: { $0.chefSpecial?.dishID == dish.dishID }) {
                CartViewController.cartItems[existingItemIndex].quantity = newQuantity
            }
        }
        
        // Notify about cart update
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": dish.dishID,
                "quantity": newQuantity,
                "isChefSpecial": true
            ]
        )
    }
    
    private func updateIntakeLimit() {
        guard let dish = currentDish else { return }
        
        // Calculate total ordered quantity
        let cartQuantity = CartViewController.cartItems
            .filter { $0.chefSpecial?.dishID == dish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.chefSpecial?.dishID == dish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let totalOrderedQuantity = cartQuantity + placedOrdersQuantity
        let remainingIntake = dish.intakeLimit - totalOrderedQuantity
        
        // Update button state
        addButton.isEnabled = remainingIntake > 0
        addButton.alpha = remainingIntake > 0 ? 1.0 : 0.5
        
        // Update stepper
        stepper.maximumValue = Double(remainingIntake + cartQuantity)
        stepper.value = Double(cartQuantity)
        quantityLabel.text = "\(cartQuantity)"
        
        // Update visibility
        stepperStackView.isHidden = cartQuantity == 0
        addButton.isHidden = cartQuantity > 0
    }
    
    @objc private func cartUpdated(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let menuItemID = userInfo["menuItemID"] as? String,
              let isChefSpecial = userInfo["isChefSpecial"] as? Bool,
              isChefSpecial,
              let dish = currentDish,
              dish.dishID == menuItemID else {
            return
        }
        
        updateIntakeLimit()
    }
    
    @objc private func handleOrderPlacement() {
        stepperStackView.isHidden = true
        addButton.isHidden = false
        addButton.isEnabled = true
        addButton.alpha = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stepperStackView.isHidden = true
        addButton.isHidden = false
        quantityLabel.text = "0"
        stepper.value = 0
        addButton.isEnabled = true
        addButton.alpha = 1.0
    }

}
