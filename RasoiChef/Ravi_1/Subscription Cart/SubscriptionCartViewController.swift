////
////  SubscriptionCartViewController.swift
////  RasoiChef
////
////  Created by Ravi Tiwari on 13/02/25.
////
//
//import UIKit
//
//class SubscriptionCartViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
//   
//    
//
//    @IBOutlet weak var subscriptionCart: UITableView!
//    var cartItems: [CartItem] = []
//    var totalPrice: Int = 0
//    var subscriptionCartItem: SubscriptionPlan?
//
//    static var cartItems: [CartItem] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        subscriptionCart.register(UINib(nibName: "SubscriptionUserCartAddress", bundle: nil), forCellReuseIdentifier: "SubscriptionUserCartAddress")
//        
//        subscriptionCart.register(UINib(nibName: "SubscriptionCartPay", bundle: nil), forCellReuseIdentifier: "SubscriptionCartPay")
//        subscriptionCart.register(UINib(nibName: "SubscriptionCartItems", bundle: nil), forCellReuseIdentifier: "SubscriptionCartItems")
//        subscriptionCart.register(UINib(nibName: "SubscriptionCartItems", bundle: nil), forCellReuseIdentifier: "SubscriptionCartItems")
//        //subscriptionCart.register(UINib(nibName: "CartDelivery", bundle: nil), forCellReuseIdentifier: "CartDelivery")
//        subscriptionCart.register(UINib(nibName: "SubscriptionCartBill", bundle: nil), forCellReuseIdentifier: "SubscriptionCartBill")
//        //subscriptionCart.register(UINib(nibName: "AddItemInCart", bundle: nil), forCellReuseIdentifier: "AddItemInCart")
//        subscriptionCart.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCartPlaceholder")
//        
//        subscriptionCart.delegate = self
//        subscriptionCart.dataSource = self
//        subscriptionCart.reloadData()
//        
//        
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1 // Address Section (1 row)
//        case 1:
//            return 1
////        case 2:
////            return CartViewController.subscriptionPlan1.isEmpty ? 0 : CartViewController.subscriptionPlan1.count
//        case 2:
//            return 1
//        case 3:
//            return 1
////        case 4:
////            return 1
//        default:
//            return 0
//        }
//    }
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return 5
////    }
////    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            // Subscription User Cart Address Cell
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionUserCartAddress", for: indexPath) as? SubscriptionUserCartAddressTableViewCell {
//                // Configure cell if needed
//                return cell
//            }
//            
//        case 1:
//            // Subscription Cart Items Cell
//            guard indexPath.row < cartItems.count else {
//                let cell = UITableViewCell()
//                cell.isHidden = true // Hide the cell
//                cell.contentView.isHidden = true
//                cell.isHidden = true
//                return cell
//            }
//
//            let item = cartItems[indexPath.row]
//            if let subscription = item.subscriptionDetails {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCartItems", for: indexPath) as? SubscriptionCartItemsCollectionTableViewCell else {
//                    fatalError("Could not dequeue SubscriptionCartItemsCollectionTableViewCell")
//                }
//              //  cell.configure(with: item)
//                cell.separatorInset = .zero
////                cell.delegate = self
//                return cell
//            } else if let menuItem = item.menuItem {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath)
//                cell.textLabel?.text = menuItem.name
//                return cell
//            }
//
//            let cell = UITableViewCell()
//            cell.textLabel?.text = "Unknown Item"
//            return cell
//            
//        case 2:
//            // Subscription Cart Bill Cell
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCartBill", for: indexPath) as? SubscriptionCartBillTableViewCell {
//                // Configure bill details if needed
//
//                return cell
//            }
//            
//        case 3:
//            // Subscription Cart Pay Cell
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCartPay", for: indexPath) as? SubscriptionCartPayTableViewCell {
//                // Configure payment details if needed
//                return cell
//            }
//
//        default:
//            break
//        }
//        
//        return UITableViewCell() // Return a default cell if none match
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 70 // Address Section Height
//        case 1:
//            return 120 // Cart Item Section Height
//        case 2:
//            return 250 // Bill Section Height
//        case 3:
//            return 70// Payment Section Height
//        
//        default:
//            return 44
//        }
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4 // Define total number of sections
//    }
//
//}
