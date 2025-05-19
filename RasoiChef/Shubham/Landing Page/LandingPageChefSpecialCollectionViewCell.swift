//
//  LandingPageChefSpecialCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

protocol LandingPageChefSpecialDetailsCellDelegate: AnyObject {
    func ChefSpecialaddButtonTapped(in cell: LandingPageChefSpecialCollectionViewCell)
}

class LandingPageChefSpecialCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : LandingPageChefSpecialDetailsCellDelegate?
    
    @IBOutlet var specialDishImage: UIImageView!
    
    @IBOutlet var timeIcon: UIImageView!
    @IBOutlet var SpecialDishName: UILabel!
    @IBOutlet var SpecialKitchenNameLabel: UILabel!
    @IBOutlet var SpecialPriceLabel: UILabel!
    @IBOutlet var SpecialRating: UILabel!
    @IBOutlet var vegicon: UIImageView!
    
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepperStackView: UIStackView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    private var currentDish: ChefSpecialtyDish?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        
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
    
    func updateSpecialDishDetails(for indexPath: IndexPath) {
        let specialDish = KitchenDataController.globalChefSpecial[indexPath.row]
        currentDish = specialDish
        print("Debug - Kitchen Name: \(specialDish.kitchenName)")
        SpecialKitchenNameLabel.text = specialDish.kitchenName
        SpecialDishName.text = specialDish.name
        SpecialPriceLabel.text = "₹\(specialDish.price)"
        SpecialRating.text = "\(String(describing: specialDish.rating))"
        
        // Load image from URL
        if let imageURL = URL(string: specialDish.imageURL) {
            loadImage(from: imageURL)
        } else {
            specialDishImage.image = UIImage(systemName: "photo") // Fallback image
        }
        
        // Set timeIcon directly from assets
        timeIcon.image = UIImage(named: "LunchIcon") ?? UIImage(systemName: "clock.fill")
        specialDishImage.layer.cornerRadius = 10
        
        if specialDish.mealCategory.contains(.veg) {
            vegicon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegicon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
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
                    self?.specialDishImage.image = UIImage(systemName: "photo") // Fallback image
                }
                return
            }
            
            DispatchQueue.main.async {
                self.specialDishImage.image = image
            }
        }.resume()
    }
    
    func setupShadow() {
        cardView.layer.masksToBounds = false  // Allow shadow to be visible outside the cell bounds
        
        cardView.layer.cornerRadius = 15 // Rounded corners
        cardView.layer.masksToBounds = true  // Ensure content respects rounded corners
        
        // Apply shadow to contentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        
        // Set shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
        
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
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
        // Reset UI state
        UIView.animate(withDuration: 0.3) {
            self.stepperStackView.isHidden = true
            self.addButton.isHidden = false
            self.addButton.isEnabled = true
            self.addButton.alpha = 1.0
            self.quantityLabel.text = "0"
            self.stepper.value = 0
        }
        
        // Clear cart items for this dish
        if let dish = currentDish {
            CartViewController.cartItems.removeAll { $0.chefSpecial?.dishID == dish.dishID }
        }
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
