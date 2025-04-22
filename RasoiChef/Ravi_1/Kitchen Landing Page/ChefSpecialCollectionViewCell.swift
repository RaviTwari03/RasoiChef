//
//  ChefSpecialCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

protocol ChefSpecialLandingPageMenuDetailsCellDelegate: AnyObject {
    func ChefSpecislDishaddButtonTapped(in cell: ChefSpecialCollectionViewCell)
}


class ChefSpecialCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : ChefSpecialLandingPageMenuDetailsCellDelegate?
    
    @IBOutlet var specialDishNameLabel: UILabel!
    @IBOutlet var specialDishRating: UILabel!
    @IBOutlet var specialDishPriceLabel: UILabel!
    @IBOutlet var specialDishIntakeLimtLabel: UILabel!
    @IBOutlet var specialDishAvailableLabel: UILabel!
    
    @IBOutlet var specialDishImage: UIImageView!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var specialCard: UIView!
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated(_:)), name: NSNotification.Name("CartUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetStepper), name: NSNotification.Name("ResetStepper"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderPlacement), name: NSNotification.Name("OrderPlaced"), object: nil)
        
        // Initial setup
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.layer.cornerRadius = 11
        stepperStackView.spacing = 8
        stepperStackView.isHidden = true
        quantityLabel.text = "0"
        
        setupUI()
    }
    
    private func setupUI() {
        // Configure Add Button
        addButton.layer.cornerRadius = 11
        addButton.backgroundColor = UIColor(named: "AccentColor") ?? .systemGreen  // Use accent color with fallback
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Configure Stepper
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.tintColor = UIColor(named: "AccentColor") ?? .systemGreen  // Match button color
        
        // Configure Quantity Label
        quantityLabel.font = .systemFont(ofSize: 16, weight: .medium)
        quantityLabel.textColor = .label
        quantityLabel.text = "0"
        
        // Initial state
        stepperStackView.isHidden = true
    }
    
    private func updateButtonState(enabled: Bool) {
        addButton.isEnabled = enabled
        addButton.alpha = enabled ? 1.0 : 0.5
        
        // Keep accent color even when disabled
        addButton.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(enabled ? 1.0 : 0.5) ?? .systemGreen
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stepperStackView.isHidden = true
        addButton.isHidden = false
        quantityLabel.text = "0"
        stepper.value = 0
        specialDishAvailableLabel.text = ""
        updateButtonState(enabled: true)
    }
    
    func updateChefSpecialDetails(with indexPath: IndexPath) {
        let items = KitchenDataController.filteredChefSpecialtyDishes.isEmpty ? KitchenDataController.chefSpecialtyDishes : KitchenDataController.filteredChefSpecialtyDishes
        let specialDish = items[indexPath.row]
        
        // Update UI with chef special details
        specialDishNameLabel.text = specialDish.name
        specialDishPriceLabel.text = "₹\(specialDish.price)"
        specialDishRating.text = "\(specialDish.rating)"
        
        // Load image from URL
        if let imageURL = URL(string: specialDish.imageURL) {
            loadImage(from: imageURL)
        } else {
            specialDishImage.image = UIImage(systemName: "photo") // Fallback image
        }
        
        specialDishIntakeLimtLabel.text = "Mon,Wed"
        
        // Calculate current state
        let cartQuantity = CartViewController.cartItems
            .filter { $0.chefSpecial?.dishID == specialDish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        // Update UI based on cart state
        if cartQuantity > 0 {
            stepperStackView.isHidden = false
            addButton.isHidden = true
            stepper.value = Double(cartQuantity)
            quantityLabel.text = "\(cartQuantity)"
        }
        
        updateCartState(for: specialDish)
        applyCardStyle1()
    }
    
    private func updateCartState(for specialDish: ChefSpecialtyDish) {
        // Calculate quantities
        let cartQuantity = CartViewController.cartItems
            .filter { $0.chefSpecial?.dishID == specialDish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.chefSpecial?.dishID == specialDish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let totalOrderedQuantity = cartQuantity + placedOrdersQuantity
        let remainingIntake = specialDish.intakeLimit - totalOrderedQuantity
        
        // Update UI
        UIView.animate(withDuration: 0.2) {
            if remainingIntake > 0 {
                self.specialDishAvailableLabel.text = "Available (\(remainingIntake) left)"
                self.specialDishAvailableLabel.textColor = .systemGreen
                self.updateButtonState(enabled: true)
            } else {
                self.specialDishAvailableLabel.text = "Unavailable"
                self.specialDishAvailableLabel.textColor = .systemRed
                self.updateButtonState(enabled: false)
            }
            
            if cartQuantity > 0 {
                self.stepperStackView.isHidden = false
                self.addButton.isHidden = true
                self.stepper.value = Double(cartQuantity)
                self.quantityLabel.text = "\(cartQuantity)"
            } else {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
                self.stepper.value = 0
                self.quantityLabel.text = "0"
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        guard let indexPath = self.indexPath else { return }
        let specialDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
        
        let newQuantity = Int(sender.value)
        
        // Update quantity label first
        UIView.animate(withDuration: 0.2) {
            self.quantityLabel.text = "\(newQuantity)"
        }
        
        // Calculate total ordered quantity
        let otherCartQuantity = CartViewController.cartItems
            .filter { item in
                guard let itemChefID = item.chefSpecial?.dishID else { return false }
                return itemChefID == specialDish.dishID
            }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter { $0.chefSpecial?.dishID == specialDish.dishID }
            .reduce(0) { $0 + $1.quantity }
        
        let totalWithNewQuantity = placedOrdersQuantity + newQuantity
        
        // Check if exceeding limit
        if totalWithNewQuantity > specialDish.intakeLimit {
            sender.value = Double(newQuantity - 1)
            self.quantityLabel.text = "\(newQuantity - 1)"
            return
        }
        
        // Handle cart updates
        if newQuantity == 0 {
            UIView.animate(withDuration: 0.2) {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
            }
            CartViewController.cartItems.removeAll { $0.chefSpecial?.dishID == specialDish.dishID }
        } else {
            if let existingItemIndex = CartViewController.cartItems.firstIndex(where: { $0.chefSpecial?.dishID == specialDish.dishID }) {
                CartViewController.cartItems[existingItemIndex].quantity = newQuantity
            } else {
                let cartItem = CartItem(
                    userAdress: "Galgotias University",
                    quantity: newQuantity,
                    specialRequest: "",
                    chefSpecial: specialDish
                )
                CartViewController.cartItems.append(cartItem)
            }
        }
        
        // Notify about cart update
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": specialDish.dishID,
                "quantity": newQuantity,
                "isChefSpecial": true
            ]
        )
    }
    
    @IBAction func SpecialDishAddButton(_ sender: Any) {
        delegate?.ChefSpecislDishaddButtonTapped(in: self)
    }
    
    @objc private func cartUpdated(_ notification: Notification) {
        guard let indexPath = self.indexPath,
              let userInfo = notification.userInfo,
              let dishID = userInfo["menuItemID"] as? String,
              let isChefSpecial = userInfo["isChefSpecial"] as? Bool,
              isChefSpecial,
              indexPath.row < KitchenDataController.chefSpecialtyDishes.count else {
            return
        }
        
        let specialDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
        if specialDish.dishID == dishID {
            // Use transition for smooth update
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                self.updateCartState(for: specialDish)
                
                // If this is an initial add, show stepper
                if let isInitialAdd = userInfo["isInitialAdd"] as? Bool, isInitialAdd {
                    self.stepperStackView.isHidden = false
                    self.addButton.isHidden = true
                    
                    // Get the quantity that was just added
                    if let quantity = userInfo["quantity"] as? Int {
                        self.stepper.value = Double(quantity)
                        self.quantityLabel.text = "\(quantity)"
                    }
                }
            }
        }
    }
    
    @objc private func resetStepper() {
        print("Resetting stepper")
        guard stepper != nil, quantityLabel != nil, stepperStackView != nil else {
            print("Error: One of the outlets is nil in resetStepper")
            return
        }
        
        stepper.value = 0
        quantityLabel.text = "0"
        stepperStackView.isHidden = true
        addButton.isHidden = false
    }
    
    @objc private func handleOrderPlacement() {
        // Hide stepper and show add button when order is placed
        stepperStackView.isHidden = true
        addButton.isHidden = false
        addButton.isEnabled = true
        addButton.alpha = 1.0
    }
    
    func applyCardStyle1() {
        specialCard.layer.cornerRadius = 15
        specialCard.layer.masksToBounds = false
        specialCard.layer.shadowColor = UIColor.black.cgColor
        specialCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        specialCard.layer.shadowRadius = 2.5
        specialCard.layer.shadowOpacity = 0.4
        specialCard.backgroundColor = .white
   }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                DispatchQueue.main.async {
                    self?.specialDishImage.image = UIImage(named: "defaultFoodImage")
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.specialDishImage.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.specialDishImage.image = UIImage(named: "defaultFoodImage")
                }
            }
        }.resume()
    }
}
