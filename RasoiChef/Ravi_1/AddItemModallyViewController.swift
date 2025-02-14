//
//  AddItemModallyViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

protocol AddItemDelegate: AnyObject {
    func didAddItemToCart(_ item: CartItem)
   
}

class AddItemModallyViewController: UIViewController, UIViewControllerTransitioningDelegate {
    weak var delegate: AddItemDelegate?
    
    var selectedItem: MenuItem?
    var selectedChefSpecialtyDish: ChefSpecialtyDish?

//    var selectedItem: MenuItem?
    var menuItems: [MenuItem] = []
    
    
    
    
    
    @IBOutlet var AddDishNameLabel: UILabel!
    
    @IBOutlet var AddDishRatingLabel: UILabel!
    @IBOutlet var AddDishPriceLabel: UILabel!
    @IBOutlet var DishDescriptionLabel: UILabel!
    @IBOutlet var AddDishButton: UIButton!
    @IBOutlet var AddDishRequestTextField: UITextField!
    
    @IBOutlet var AddDishItemCounterLabel: UILabel!
    @IBOutlet var AddIncreaseDishButton: UIStepper!
    



    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalSize()
        AddDishButton.layer.cornerRadius = 11

        // Check whether we have a MenuItem or ChefSpecialtyDish and populate UI
        if let item = selectedItem {
            print("Selected MenuItem: \(item.name)")  // Debugging print
            AddDishNameLabel.text = item.name
            AddDishRatingLabel.text = "⭐ \(item.rating)"
            AddDishPriceLabel.text = "₹\(item.price)"
            DishDescriptionLabel.text = item.description
            AddDishRequestTextField.text = ""
            AddDishItemCounterLabel.text = "1"
            AddIncreaseDishButton.value = 1
        } else if let chefDish = selectedChefSpecialtyDish {
            print("Selected ChefSpecialtyDish: \(chefDish.name)")  // Debugging print
            AddDishNameLabel.text = chefDish.name
            AddDishRatingLabel.text = "⭐ \(chefDish.rating)"
            AddDishPriceLabel.text = "₹\(chefDish.price)"
            DishDescriptionLabel.text = chefDish.description
            AddDishRequestTextField.text = ""
            AddDishItemCounterLabel.text = "1"
            AddIncreaseDishButton.value = 1
        } else {
            print("Error: No data passed.")
        }
    }

    private func configureModalSize() {
        // Set the modal presentation style
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    func presentAddItemModally(selectedItem: MenuItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            addItemVC.selectedItem = selectedItem
            self.present(addItemVC, animated: true, completion: nil)
        }
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        AddDishItemCounterLabel.text = "\(Int(sender.value))"
    }

    
    
    
    //    MARK: - For cart
  
    @IBAction func addDishButtonTapped(_ sender: UIButton) {
//        guard let item = selectedItem else { return }
//            let quantity = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
//            let specialRequest = AddDishRequestTextField.text ?? ""
//
//            let cartItem = CartItem(
//                userAdress: "Galgotias University", // Replace with an actual address if needed
//                quantity: quantity,
//                specialRequest: specialRequest,
//                menuItem: item
//            )
//
//            // Add the item to the cart
//            KitchenDataController.cartItems.append(cartItem)
//            CartViewController.cartItems.append(cartItem)
//
//            // Debugging: Print the cart items to verify
//            print("Cart Items: \(CartViewController.cartItems)")
//
//            // Update the tab badge
//            updateCartBadge() // Call the method to handle badge update
//
//            print("Item added to cart: \(cartItem)") // Log the added item
//
//            // Dismiss the current view controller if presented modally
//            if self.presentingViewController != nil {
//                self.dismiss(animated: true, completion: nil)
//            }
        var cartItem: CartItem?

           let quantity = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
           let specialRequest = AddDishRequestTextField.text ?? ""

           if let item = selectedItem {
               // If it's a regular menu item
               cartItem = CartItem(
                   userAdress: "Galgotias University", // Replace with an actual address if needed
                   quantity: quantity,
                   specialRequest: specialRequest,
                   menuItem: item
                   //chefSpecial: nil
               )
           } else if let chefDish = selectedChefSpecialtyDish {
               // If it's a Chef Specialty dish
               cartItem = CartItem(
                   userAdress: "Galgotias University", // Replace with an actual address if needed
                   quantity: quantity,
                   specialRequest: specialRequest,
                 //  menuItem: chefDish,
                   chefSpecial: chefDish
               )
               print("\(chefDish.price)")
           }

           // Ensure cartItem is not nil before proceeding
           if let cartItem = cartItem {
               // Add the item to the cart
               KitchenDataController.cartItems.append(cartItem)
               CartViewController.cartItems.append(cartItem)
               delegate?.didAddItemToCart(cartItem)


               // Debugging: Print the cart items to verify
               print("Cart Items: \(CartViewController.cartItems)")

               // Update the tab bar badge
              // updateCartBadge() // Call the method to handle badge update

               print("Item added to cart: \(cartItem)") // Log the added item

               // Dismiss the current view controller if presented modally
               if self.presentingViewController != nil {
                   self.dismiss(animated: true, completion: nil)
               }
           } else {
               print("Error: No valid item selected to add to cart.")
           }
        }

        }

        // Helper function to update the badge
//        func updateCartBadge() {
//            DispatchQueue.main.async {
//                if let tabItems = self.tabBarController?.tabBar.items {
//                    let cartTabItem = tabItems[2] // Assuming "Cart" is the third tab
//                    let itemCount = CartViewController.cartItems.count
//                    cartTabItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
//                    // Debugging: Print the badge value to verify
//                    print("Badge Value: \(cartTabItem.badgeValue ?? "nil")")
//                }
//            }
//        }
//    func presentAddItemModally(selectedItem: MenuItem?, selectedChefSpecialtyDish: ChefSpecialtyDish?) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let addItemVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
//            addItemVC.selectedItem = selectedItem
//            addItemVC.selectedChefSpecialtyDish = selectedChefSpecialtyDish
//            self.present(addItemVC, animated: true, completion: nil)
//        }
    

    


