//
//  OrderDataController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation

class OrderDataController{
    private var orders:[Order] = []
//    private var pastOrders:[Order] = []
    
    private init(){
        loadDummyOrders()
//        pastOrdersdummyData()
    }
    
    static var shared = OrderDataController()
    
//    static var sharedPastOrders = OrderDataController()
    
    func getOrders() -> [Order] {
            return orders
        }
        
        func getOrderCount() -> Int {
            return orders.count
        }
    func addOrder(order: Order) {
            orders.append(order)
            // After adding the new order, re-sort them by status (current orders first)
            sortOrdersByStatus()
        }
    
    // Sort orders into current and past orders based on their status
        func sortOrdersByStatus() {
            MyOrdersViewController.shared.currentOrders = orders.filter { $0.status != .delivered }
            MyOrdersViewController.shared.pastOrders = orders.filter { $0.status == .delivered }
        }

    
    func loadDummyOrders() {
            // Dummy orders with different statuses
            orders = [
                Order(orderID: "1", userID: "1", kitchenID: "1", items: [OrderItem(menuItemID: "gulab jamun", quantity: 2, price: 500),OrderItem(menuItemID: "3", quantity: 2, price: 600)], status: .placed, totalAmount: 500, deliveryAddress: "abc 123", deliveryDate: Date(), deliveryType: "delivery"),
                Order(orderID: "2", userID: "1", kitchenID: "1", items: [OrderItem(menuItemID: "2", quantity: 1, price: 300)], status: .delivered, totalAmount: 300, deliveryAddress: "xyz 456", deliveryDate: Date().addingTimeInterval(-3600), deliveryType: "pickup"),
                Order(orderID: "3", userID: "2", kitchenID: "2", items: [OrderItem(menuItemID: "3", quantity: 3, price: 400)], status: .placed, totalAmount: 1200, deliveryAddress: "ghi 789", deliveryDate: Date(), deliveryType: "delivery"),
                Order(orderID: "4", userID: "2", kitchenID: "2", items: [OrderItem(menuItemID: "4", quantity: 1, price: 150)], status: .delivered, totalAmount: 150, deliveryAddress: "jkl 012", deliveryDate: Date().addingTimeInterval(-7200), deliveryType: "pickup")
            ]
            
            sortOrdersByStatus()  // Ensure the orders are categorized correctly into current and past orders
        }
    
//    func getPastOrderCount() -> Int {
//        return pastOrders.count
//    }
    
//        func loadDummyOrders(){
//            orders = [
//                Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
//                Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
//               
//            ]
//            
//        }
//         func pastOrdersdummyData(){
//            pastOrders = [
//                Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
//                Order(orderID: UUID(), orderNumber: "order 2", homecook: HomeCook(name: "Rana Ji Rasoi"), items: [Meal(name: "Paneer")], date: Date())]
//                }
}
    
    
            
