//
//  ChefSpecialMenuCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit
protocol ChefSpecialMenuDetailsCellDelegate: AnyObject {
    func MenuListaddButtonTapped(in cell: ChefSpecialMenuCollectionViewCell, dish: ChefSpecialtyDish)
}
class ChefSpecialMenuCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : ChefSpecialMenuDetailsCellDelegate?
    
    @IBOutlet var specialDishImage: UIImageView!
    @IBOutlet var specialDishName: UILabel!
    @IBOutlet var specialDishPrice: UILabel!
    @IBOutlet var kitchenName: UILabel!
    
    @IBOutlet var specialDishRating: UILabel!
    @IBOutlet var Distance: UILabel!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet weak var vegNonvegIcon: UIImageView!
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    private var currentDish: ChefSpecialtyDish?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.layer.cornerRadius = 11
        stepperStackView.spacing = 3
        
        // Add observers for cart updates and order placement
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated(_:)),
            name: NSNotification.Name("CartUpdated"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orderPlaced(_:)),
            name: NSNotification.Name("OrderPlaced"),
            object: nil
        )
        
        // Initial setup
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepperStackView.isHidden = true
        addButton.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateSpecialDishDetails(with specialDish: ChefSpecialtyDish) {
        self.currentDish = specialDish
        specialDishName.text = specialDish.name
        specialDishPrice.text = "₹\(specialDish.price)"
        kitchenName.text = specialDish.kitchenName
        specialDishRating.text = "\(specialDish.rating)"
        Distance.text = "\(specialDish.distance) km"
        
        // Load image from URL
        if let imageURL = URL(string: specialDish.imageURL) {
            loadImage(from: imageURL)
        } else {
            specialDishImage.image = UIImage(systemName: "photo") // Fallback image
        }

        if specialDish.mealCategory.contains(.veg) {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonvegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
        
        // Configure stepper
        stepper.minimumValue = 0
        stepper.maximumValue = Double(specialDish.intakeLimit)
        stepper.stepValue = 1
        
        updateCartState(for: specialDish)
    }
    
    private func updateCartState(for dish: ChefSpecialtyDish) {
        // Check if item is in cart
        if let cartItem = CartViewController.cartItems.first(where: { $0.chefSpecial?.dishID == dish.dishID }) {
            stepperStackView.isHidden = false
            addButton.isHidden = true
            stepper.value = Double(cartItem.quantity)
            quantityLabel.text = "\(cartItem.quantity)"
        } else {
            stepperStackView.isHidden = true
            addButton.isHidden = false
            stepper.value = 0
            quantityLabel.text = "0"
        }
    }
    
    @objc private func cartUpdated(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let dishID = userInfo["menuItemID"] as? String,
              let isChefSpecial = userInfo["isChefSpecial"] as? Bool,
              isChefSpecial,
              let currentDish = self.currentDish,
              currentDish.dishID == dishID else {
            return
        }
        
        // Use transition for smooth update
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
            self.updateCartState(for: currentDish)
        }
    }
    
    @objc private func orderPlaced(_ notification: Notification) {
        // Reset the cell state when an order is placed
        UIView.animate(withDuration: 0.2) {
            self.stepperStackView.isHidden = true
            self.addButton.isHidden = false
        }
        stepper.value = 0
        quantityLabel.text = "0"
    }
    
    @IBAction func ChefSpecialAddButtonTapped(_ sender: Any) {
        guard let dish = currentDish else { return }
        delegate?.MenuListaddButtonTapped(in: self, dish: dish)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        guard let dish = currentDish else { return }
        
        let newQuantity = Int(sender.value)
        quantityLabel.text = "\(newQuantity)"
        
        // Calculate total ordered quantity
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
        
        // Handle cart updates
        if newQuantity == 0 {
            UIView.animate(withDuration: 0.2) {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
            }
            CartViewController.cartItems.removeAll { $0.chefSpecial?.dishID == dish.dishID }
        } else {
            if let existingItemIndex = CartViewController.cartItems.firstIndex(where: { $0.chefSpecial?.dishID == dish.dishID }) {
                CartViewController.cartItems[existingItemIndex].quantity = newQuantity
            } else {
                let cartItem = CartItem(
                    userAdress: "Galgotias University",
                    quantity: newQuantity,
                    specialRequest: "",
                    chefSpecial: dish
                )
                CartViewController.cartItems.append(cartItem)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stepperStackView.isHidden = true
        addButton.isHidden = false
        quantityLabel.text = "0"
        stepper.value = 0
        currentDish = nil
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.specialDishImage.image = UIImage(systemName: "photo") // Fallback image
                }
                return
            }
            
            DispatchQueue.main.async {
                self.specialDishImage.image = image
            }
        }.resume()
    }
}
