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
        guard let item = selectedItem else {
            print("Error: No item data passed.")
            return}
        
        AddDishNameLabel.text = item.name
        AddDishRatingLabel.text = "⭐ \(item.rating)"
        AddDishPriceLabel.text = "₹\(item.price)"
        DishDescriptionLabel.text = item.description
        
       
        AddDishRequestTextField.text = ""
        AddDishItemCounterLabel.text = "1"
        AddIncreaseDishButton.value = 1
    
       
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
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    
    
    
    //    MARK: - For cart
  
    @IBAction func addDishButtonTapped(_ sender: UIButton) {
        guard let item = selectedItem else { return }
        let quantity = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
        let specialRequest = AddDishRequestTextField.text ?? ""

     
        let cartItem = CartItem(
            userAdress: "Galgotias University", // Replace "nil" with an actual address if needed
            
           
            quantity: quantity,
            specialRequest: specialRequest,
            menuItem: item)
        KitchenDataController.cartItems.append(cartItem)
            print("Item added to cart: \(cartItem)")  // Log the added item
//            CartItem.reloadData()  // Refresh the table view
            

       
        CartViewController.cartItems.append(cartItem)
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }

   
    }



