//
//  CartViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit



class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddItemDelegate {
    
    
    
    
    @IBOutlet var CartItem: UITableView!

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
        CartItem.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCartPlaceholder")

        CartItem.delegate = self
        CartItem.dataSource = self
        CartItem.reloadData()

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Four sections: Address, Cart Items, Bill, and Payment
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Address Section (1 row)
        case 1:
            return CartViewController.cartItems.isEmpty ? 1 : CartViewController.cartItems.count
        case 2:
            return CartViewController.cartItems.isEmpty ? 0 : 1 // Bill Section (1 row)
        case 3:
            return CartViewController.cartItems.isEmpty ? 0 : 1
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            // Address Section
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartAddress", for: indexPath) as! UserCartAddressTableViewCell
//            // cell.updateUserAddress(for: indexPath) // Assuming you have a configure method in the cell
//            return cell
//        case 1:
//            if CartViewController.cartItems.isEmpty {
//                       // Placeholder cell for an empty cart
//                       let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartPlaceholder", for: indexPath)
//                       cell.textLabel?.text = "Your cart is empty. Add some items!"
//                       cell.textLabel?.textAlignment = .center
//                       cell.textLabel?.textColor = .gray
//                
//                       return cell
//                   } else {
//                       // Cart Items Section
//                       let cell = tableView.dequeueReusableCell(withIdentifier: "CartItems", for: indexPath) as! CartItemTableViewCell
//                       let cartItem = CartViewController.cartItems[indexPath.row]
//                       cell.updateCartItem(for: indexPath)
//                       
//                       return cell
//                   }
//        case 2:
////            // Bill Section
////            if CartViewController.cartItems.isEmpty {
////                // Placeholder cell for an empty cart
////                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartPlaceholder", for: indexPath)
////                cell.textLabel?.text = "Your cart is empty. Add some items!"
////                cell.textLabel?.textAlignment = .center
////                cell.textLabel?.textColor = .gray
////                return cell}else{
////                    let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as! CartBillTableViewCell
////                    //                et totalAmount = calculateTotalAmount()
////                    //                cell.configure(with: totalAmount) // Assuming a configure method for the bill
////                    return cell}
//            if CartViewController.cartItems.isEmpty {
//                       // No need to create a placeholder cell as the row count is 0
//                       return UITableViewCell()
//                   } else {
//                       let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as! CartBillTableViewCell
//                       // Configure the cell as needed
//                       return cell
//                   }
//               
//        case 3:
//            // Payment Section
////            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath) as! CartPayTableViewCell
////            return cell
//            if CartViewController.cartItems.isEmpty {
//                       // No need to create a placeholder cell as the row count is 0
//                       return UITableViewCell()
//                   } else {
//                       let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath) as! CartPayTableViewCell
//                       // Configure the cell as needed
//                       return cell
//                   }
//        default:
//            return UITableViewCell()
//        }
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Address Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartAddress", for: indexPath) as? UserCartAddressTableViewCell else {
                return UITableViewCell()
            }
            cell.updateAddress(with: indexPath)
            return cell
            
        case 1:
            // Cart Items Section
            if CartViewController.cartItems.isEmpty {
                // Placeholder cell for an empty cart
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartPlaceholder", for: indexPath)
                cell.textLabel?.text = "Your cart is empty. Add some items!"
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .gray
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItems", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                cell.updateCartItem(for: indexPath)
                return cell
            }
            
        case 2:
            // Bill Section
            if CartViewController.cartItems.isEmpty {
                return UITableViewCell() // No cell needed when the cart is empty
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as? CartBillTableViewCell else {
                    return UITableViewCell()
                }
                // Configure the cell as needed
                // Example: cell.configure(with: totalAmount)
                return cell
            }
            
        case 3:
            // Payment Section
            if CartViewController.cartItems.isEmpty {
                return UITableViewCell() // No cell needed when the cart is empty
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath) as? CartPayTableViewCell else {
                    return UITableViewCell()
                }
                // Configure the cell as needed
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70 // Address Section Height
        case 1:
            return 110 // Cart Item Section Height
        case 2:
            return 250 // Bill Section Height
        case 3:
            return 80 // Payment Section Height
        default:
            return 44
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Delivery Address"
//        case 1:
//            return "Cart Items"
//        case 2:
//            return CartViewController.cartItems.isEmpty ? nil : "Bill Summary"
//        case 3:
//            return "Payment"
//        default:
//            return nil
//        }
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Delivery Address"
        case 1:
            return "Cart Items"
        case 2:
            return CartViewController.cartItems.isEmpty ? nil : "Bill Summary"
        case 3:
            return CartViewController.cartItems.isEmpty ? nil : "Payment"
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
        KitchenDataController.cartItems.append(item)
        if KitchenDataController.cartItems.isEmpty {
            print("No items to display in the cart.")
        } else {
            print("Items added to cart. Current count: \(KitchenDataController.cartItems.count)")
        }
        CartItem.reloadData()  // Refresh table view
    }

        
    }

