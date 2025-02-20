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
//protocol AddItemDelegate: AnyObject {
//    func didAddItemToCart(_ item: CartItem, quantity: Int)
//}

class AddItemModallyViewController: UIViewController, UIViewControllerTransitioningDelegate {
    weak var delegate: AddItemDelegate?
    
    var selectedItem: MenuItem?
    var selectedChefSpecialtyDish: ChefSpecialtyDish?

//    var selectedItem: MenuItem?
   // var menuItems: [MenuItem] = []
    
    
    
    
    
    @IBOutlet var AddDishNameLabel: UILabel!
    
    @IBOutlet var AddDishRatingLabel: UILabel!
    @IBOutlet var AddDishPriceLabel: UILabel!
    @IBOutlet var DishDescriptionLabel: UILabel!
    @IBOutlet var AddDishButton: UIButton!
    @IBOutlet var AddDishRequestTextField: UITextField!
    
    @IBOutlet var AddDishItemCounterLabel: UILabel!
    @IBOutlet var AddIncreaseDishButton: UIStepper!
    
    @IBOutlet weak var AddDishImage: UIImageView!
    
    @IBOutlet weak var kitchenName: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalSize()
        AddDishButton.layer.cornerRadius = 11

        // Check whether we have a MenuItem or ChefSpecialtyDish and populate UI
        if let item = selectedItem {
            print("Selected MenuItem: \(item.name)")  // Debugging print
            AddDishNameLabel.text = item.name
            AddDishRatingLabel.text = "\(item.rating)"
            AddDishPriceLabel.text = "₹\(item.price)"
            DishDescriptionLabel.text = item.description
            AddDishRequestTextField.text = ""
            AddDishItemCounterLabel.text = "1"
            AddIncreaseDishButton.value = 1
            AddDishImage.image = UIImage(named: item.imageURL)
            kitchenName.text = item.kitchenName
        } else if let chefDish = selectedChefSpecialtyDish {
            print("Selected ChefSpecialtyDish: \(chefDish.name)")  // Debugging print
            AddDishNameLabel.text = chefDish.name
            AddDishRatingLabel.text = "\(chefDish.rating)"
            AddDishPriceLabel.text = "₹\(chefDish.price)"
            DishDescriptionLabel.text = chefDish.description
            AddDishRequestTextField.text = ""
            AddDishItemCounterLabel.text = "1"
            AddIncreaseDishButton.value = 1
            AddDishImage.image = UIImage(named: chefDish.imageURL)
            kitchenName.text = chefDish.kitchenName
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
        let quantity = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
            let specialRequest = AddDishRequestTextField.text ?? ""

            var cartItem: CartItem?

            if let item = selectedItem {
                // Regular menu item
                cartItem = CartItem(
                    userAdress: "Galgotias University",
                    quantity: quantity,
                    specialRequest: specialRequest,
                    menuItem: item
                )
            } else if let chefDish = selectedChefSpecialtyDish {
                // Chef Specialty dish
                cartItem = CartItem(
                    userAdress: "Galgotias University",
                    quantity: quantity,
                    specialRequest: specialRequest,
                    chefSpecial: chefDish
                )
            }

            guard let cartItem = cartItem else {
                print("Error: No valid item selected to add to cart.")
                return
            }

            // **Check if item already exists in the cart**
            if let existingIndex = CartViewController.cartItems.firstIndex(where: {
                ($0.menuItem?.itemID == cartItem.menuItem?.itemID) || ($0.chefSpecial?.dishID == cartItem.chefSpecial?.dishID)
            }) {
                // **If found, update the quantity instead of adding a new item**
                CartViewController.cartItems[existingIndex].quantity += quantity
                print("Updated existing item quantity: \(CartViewController.cartItems[existingIndex].quantity)")
            } else {
                // **Else, add a new item**
                CartViewController.cartItems.append(cartItem)
            }

            // Sync with `KitchenDataController`
            KitchenDataController.cartItems = CartViewController.cartItems

            // Debugging print
            print("Cart Items: \(CartViewController.cartItems)")

            // Update cart badge
            // updateCartBadge()

            // **Reload cart data**
            NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)

            // Dismiss modal if presented
            if self.presentingViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }

    @IBAction func crossButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

  


