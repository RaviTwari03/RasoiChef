//
//  KitchenMenuCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

protocol KitchenMenuDetailsCellDelegate: AnyObject {
    func KitchenMenuListaddButtonTapped(in cell: KitchenMenuCollectionViewCell)
}


class KitchenMenuCollectionViewCell: UICollectionViewCell  {
    
    var isExpanded: Bool = false

    
    @IBOutlet var vegImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var dishNameLabel: UILabel!
    @IBOutlet var dishDescription: UILabel!
    @IBOutlet var dishprice: UILabel!
    @IBOutlet var dishImge: UIImageView!
    @IBOutlet var dishTime: UILabel!
    @IBOutlet var dishDeliveryExpected: UILabel!
    
    @IBOutlet var cardViewKitchenMenu: UIView!
    @IBOutlet var dishIntakLimit: UILabel!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
       
    

    weak var delegate: KitchenMenuDetailsCellDelegate?
          
        override func awakeFromNib() {
                  super.awakeFromNib()
                  
                  // Set up observers
                  NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: NSNotification.Name("CartUpdated"), object: nil)
                  NotificationCenter.default.addObserver(self, selector: #selector(handleOrderPlacement), name: NSNotification.Name("OrderPlaced"), object: nil)
                  
                  // Initial stepper setup
                  if let stepper = stepper {
                      stepper.minimumValue = 0
                      stepper.stepValue = 1
                      stepper.layer.cornerRadius = 11
                      stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
                  }
                  
                  // Initial UI state
                  stepperStackView?.isHidden = true
                  addButton?.isHidden = false
                  quantityLabel?.text = "0"
                  
                  // Apply initial styling
                  setupCardStyle()
              }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func cartUpdated() {
        if let collectionView = self.superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self),
           indexPath.row < KitchenDataController.menuItems.count {
            
            // Update the quantity label if the item is in the cart
            let menuItem = KitchenDataController.menuItems[indexPath.row]
            let orderedQuantity = CartViewController.cartItems
                .filter { $0.menuItem?.itemID == menuItem.itemID }
                .reduce(0) { $0 + $1.quantity }
            
            // Update UI safely
            DispatchQueue.main.async {
                if orderedQuantity > 0 {
                    self.stepperStackView.isHidden = false
                    self.addButton.isHidden = true
                    self.quantityLabel.text = "\(orderedQuantity)"
                    self.stepper.value = Double(orderedQuantity)
                } else {
                    self.stepperStackView.isHidden = true
                    self.addButton.isHidden = false
                    self.quantityLabel.text = "0"
                }
            }
            
            // Update intake limit
            updateIntakeLimit(for: indexPath)
        }
    }

    @objc private func handleOrderPlacement() {
        // Safely handle UI updates on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Safely update stepper stack view
            if let stepperStackView = self.stepperStackView {
                stepperStackView.isHidden = true
            }
            
            // Safely update add button
            if let addButton = self.addButton {
                addButton.isHidden = false
                addButton.isEnabled = true
                addButton.alpha = 1.0
            }
        }
    }

    func checkAvailability(for menuItem: MenuItem) -> Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        // Check time-based availability
        let isAvailable: Bool = {
            guard let mealType = menuItem.availableMealTypes else {
                return false
            }
            switch mealType {
            case .breakfast where currentHour < 6:   return true  // Until 6 AM
            case .lunch where currentHour < 11:      return true  // Until 11 AM
            case .snacks where currentHour < 15:     return true  // Until 3 PM
            case .dinner where currentHour < 19:     return true  // Until 7 PM
            default: return false
            }
        }()
        
        // Check intake limit
        let hasAvailableIntake = menuItem.intakeLimit > 0
        
        return isAvailable && hasAvailableIntake
    }

    func updateMealDetails(with menuItem: MenuItem, at indexPath: IndexPath) {
        // Update basic details
        dishNameLabel.text = menuItem.name
        ratingLabel.text = String(format: "%.1f", menuItem.rating)
        dishprice.text = "₹\(menuItem.price)"
        dishTime.text = menuItem.availableMealTypes?.rawValue.capitalized ?? "Not specified"
        dishDeliveryExpected.text = "Order Before \(menuItem.orderDeadline)"
        
        // Handle veg/non-veg icon
        if menuItem.mealCategory.contains(.veg) {
            vegImage.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegImage.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
        
        // Handle description with read more functionality
        let words = menuItem.description.split(separator: " ")
        if words.count > 9 {
            let truncatedText = words.prefix(9).joined(separator: " ") + "...read more"
            let attributedString = NSMutableAttributedString(string: truncatedText)
            let readMoreRange = (truncatedText as NSString).range(of: "...read more")
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: readMoreRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readMoreRange)
            
            dishDescription.attributedText = attributedString
            dishDescription.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(readMoreTapped))
            dishDescription.addGestureRecognizer(tapGesture)
        } else {
            dishDescription.text = menuItem.description
        }
        
        // Load image from URL
        if let imageURL = URL(string: menuItem.imageURL) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.dishImge.image = UIImage(named: "defaultFoodImage")
                    }
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.dishImge.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.dishImge.image = UIImage(named: "defaultFoodImage")
                    }
                }
            }.resume()
        } else {
            dishImge.image = UIImage(named: "defaultFoodImage")
        }
        
        // Check availability and update UI accordingly
        let isAvailable = checkAvailability(for: menuItem)
        setAvailability(isAvailable)
        
        // Update intake limit and cart state
        updateIntakeLimit(for: indexPath)
        
        // Apply card styling
        applyCardStyle1()
    }

    private func setupCardStyle() {
        // Ensure the card view exists before applying styles
        guard let cardView = cardViewKitchenMenu else { return }
        
        cardView.layer.cornerRadius = 15
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2.5
        cardView.layer.shadowOpacity = 0.4
        cardView.backgroundColor = .white
    }

    func applyCardStyle1() {
        setupCardStyle()
    }
   
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.KitchenMenuListaddButtonTapped(in: self)
        
        // Hide Add Button and Show Stepper
        addButton.isHidden = true
        stepperStackView.isHidden = false

        // Set initial quantity to 1
        stepper.value = 1
        quantityLabel.text = "1"

        if let collectionView = self.superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self) {
            updateIntakeLimit(for: indexPath)
        }
    }

    @objc func readMoreTapped() {
        isExpanded.toggle()

        let fullText = KitchenDataController.menuItems.first(where: { $0.name == dishNameLabel.text })?.description ?? ""
        dishDescription.text = isExpanded ? fullText : fullText.split(separator: " ").prefix(9).joined(separator: " ") + "...read more"
        
        UIView.animate(withDuration: 0.3) {
            self.superview?.superview?.layoutIfNeeded()
        }
        
        if let collectionView = self.superview as? UICollectionView {
            if collectionView.indexPath(for: self) != nil {
                collectionView.performBatchUpdates(nil, completion: nil)
            }
        }
    }


@objc func stepperValueChanged(_ sender: UIStepper) {
    let newQuantity = Int(sender.value)
    quantityLabel.text = "\(newQuantity)"

    guard let collectionView = self.superview as? UICollectionView,
          let indexPath = collectionView.indexPath(for: self) else { return }

    let menuItem = KitchenDataController.menuItems[indexPath.row]
    // Check if this is a chef special dish
    let chefSpecial = KitchenDataController.chefSpecialtyDishes.first { $0.dishID == menuItem.itemID }
    let isChefSpecial = chefSpecial != nil

    // Find or create cart item
    if let cartItemIndex = CartViewController.cartItems.firstIndex(where: {
        if isChefSpecial {
            return $0.chefSpecial?.dishID == menuItem.itemID
        } else {
            return $0.menuItem?.itemID == menuItem.itemID
        }
    }) {
        // Update existing cart item
        CartViewController.cartItems[cartItemIndex].quantity = newQuantity
        
        if newQuantity == 0 {
            CartViewController.cartItems.remove(at: cartItemIndex)
            addButton.isHidden = false
            stepperStackView.isHidden = true
        }
    } else if newQuantity > 0 {
        // Create new cart item
        let newCartItem: CartItem
        if let chefSpecial = chefSpecial {
            newCartItem = CartItem(userAdress: "", quantity: newQuantity, chefSpecial: chefSpecial)
        } else {
            newCartItem = CartItem(userAdress: "", quantity: newQuantity, menuItem: menuItem)
        }
        CartViewController.cartItems.append(newCartItem)
        addButton.isHidden = true
        stepperStackView.isHidden = false
    }

    updateIntakeLimit(for: indexPath)
    
    // Post notification with the updated item info
    NotificationCenter.default.post(
        name: NSNotification.Name("CartUpdated"),
        object: nil,
        userInfo: [
            "menuItemID": menuItem.itemID,
            "quantity": newQuantity,
            "isChefSpecial": isChefSpecial
        ]
    )
}





func updateIntakeLimit(for indexPath: IndexPath) {
    let menuItem = KitchenDataController.menuItems[indexPath.row]
    let chefSpecial = KitchenDataController.chefSpecialtyDishes.first { $0.dishID == menuItem.itemID }
    let isChefSpecial = chefSpecial != nil
    
    // Get total ordered quantity from both current cart and placed orders
    let cartQuantity = CartViewController.cartItems
        .filter {
            if isChefSpecial {
                return $0.chefSpecial?.dishID == menuItem.itemID
            } else {
                return $0.menuItem?.itemID == menuItem.itemID
            }
        }
        .reduce(0) { $0 + $1.quantity }
    
    let placedOrdersQuantity = OrderHistoryController.placedOrders
        .flatMap { $0.items }
        .filter {
            if isChefSpecial {
                return $0.chefSpecial?.dishID == menuItem.itemID
            } else {
                return $0.menuItem?.itemID == menuItem.itemID
            }
        }
        .reduce(0) { $0 + $1.quantity }
    
    let totalOrderedQuantity = cartQuantity + placedOrdersQuantity
    let intakeLimit = isChefSpecial ? chefSpecial?.intakeLimit ?? menuItem.intakeLimit : menuItem.intakeLimit
    let remainingIntake = max(intakeLimit - totalOrderedQuantity, 0)

    // Update UI
    dishIntakLimit.text = "Intake limit: \(remainingIntake)"
    addButton.isEnabled = remainingIntake > 0
    addButton.alpha = remainingIntake > 0 ? 1.0 : 0.5

    // Update stepper
    stepper.maximumValue = Double(remainingIntake + cartQuantity) ?? 0.0
    stepper.minimumValue = 0
    stepper.value = Double(cartQuantity)
    stepper.isEnabled = true
    quantityLabel.text = "\(cartQuantity)"

    // Toggle visibility
    stepperStackView.isHidden = cartQuantity == 0
    addButton.isHidden = cartQuantity > 0
}

func setAvailability(_ isAvailable: Bool) {
    // Remove any existing blur view first
    contentView.subviews.forEach { view in
        if view is UIVisualEffectView {
            view.removeFromSuperview()
        }
    }
    
    if !isAvailable {
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = contentView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurView)
        contentView.sendSubviewToBack(blurView)
        
        // Disable interaction
        isUserInteractionEnabled = false
        addButton.isEnabled = false
        contentView.alpha = 0.7
    } else {
        // Enable interaction
        isUserInteractionEnabled = true
        addButton.isEnabled = true
        contentView.alpha = 1.0
    }
}
}
