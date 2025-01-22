//
//  CartViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit



class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddItemDelegate {
    
    
    
    
    @IBOutlet var CartItem: UITableView!
//    static var cartItems: [CartItem] = []
//    
    static var cartItems: [CartItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        CartItem.register(UINib(nibName: "UserCartAddress", bundle: nil), forCellReuseIdentifier: "UserCartAddress")
        
        CartItem.register(UINib(nibName: "CartPay", bundle: nil), forCellReuseIdentifier: "CartPay")
        CartItem.register(UINib(nibName: "CartItems", bundle: nil), forCellReuseIdentifier: "CartItems")
        CartItem.register(UINib(nibName: "CartDelivery", bundle: nil), forCellReuseIdentifier: "CartDelivery")
        CartItem.register(UINib(nibName: "CartBill", bundle: nil), forCellReuseIdentifier: "CartBill")
        CartItem.register(UINib(nibName: "AddItemInCart", bundle: nil), forCellReuseIdentifier: "AddItemInCart")
        
        CartItem.delegate = self
        CartItem.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 // Four sections: Address, Cart Items, Bill, and Payment
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Address Section (1 row)
        case 1:
            return 1/* CartViewController.cartItems.count*/ // Cart Items Section
        case 2:
            return 1
        case 3:
            return 1 // Bill Section (1 row)
        case 4:
            return 1 // Payment Section (1 row)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Address Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartAddress", for: indexPath) as! UserCartAddressTableViewCell
            // cell.updateUserAddress(for: indexPath) // Assuming you have a configure method in the cell
            return cell
        case 1:
            // Cart Items Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItems", for: indexPath) as! CartItemTableViewCell
            //let cartItem = CartViewController.cartItems[indexPath.row]
//            cell.updateCartItem(for: indexPath) // Assuming a configure method for cart items
            return cell
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CartDelivery", for: indexPath) as? CartDeliveryTableViewCell {
                return cell
            } else {
                // Handle the error gracefully by returning a default UITableViewCell or logging an issue
                print("Error: CartDelivery cell could not be dequeued")
                return UITableViewCell() // Default cell, could log or handle better
            }
        case 3:
            // Bill Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as! CartBillTableViewCell
            //                et totalAmount = calculateTotalAmount()
            //                cell.configure(with: totalAmount) // Assuming a configure method for the bill
            return cell
            
        case 4:
            // Payment Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath) as! CartPayTableViewCell
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120 // Address Section Height
        case 1:
            return 150 // Cart Item Section Height
        case 2:
            return 250 // Bill Section Height
        case 3:
            return 100 // Payment Section Height
        case 4:
            return 80
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Delivery Address"
        case 1:
            return "Items"
        case 2:
            return "Bill Summary"
        case 3:
            return "Payment"
        case 4:
            return "Delivery Options"
        default:
            return nil
        }
    }
//    func didAddItemToCart(_ item: CartItem) {
//        CartViewController.cartItems.append(item)
//        CartItem.reloadData() // Refresh table view
//    }
    func presentAddItemModal(with item: MenuItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            addItemVC.selectedItem = item
            addItemVC.delegate = self // Set the delegate
            self.present(addItemVC, animated: true, completion: nil)
        }
        //        func calculateTotalAmount() -> Double {
        //            // Calculate the total amount based on cart items
        //            return CartViewController.cartItems.reduce(into: 0) { $0 + ($1.price * Double($1.quantity)) }
        //        }
    }
//    extension CartViewController: AddItemDelegate {
        func didAddItemToCart(_ item: CartItem) {
            CartViewController.cartItems.append(item) // Add item to the cart array
            CartItem.reloadData() // Refresh table view to reflect the changes
        }
    
        
        
    }

