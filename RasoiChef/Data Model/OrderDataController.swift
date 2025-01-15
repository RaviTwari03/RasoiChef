//
//  OrderDataController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation

class OrderDataController{
    private var orders:[Order] = []
    
    private init(){
        loadDummyOrders()
    }
    
    static var shared = OrderDataController()
    
    func getOrderCount() -> Int {
        return orders.count
    }
    
    func loadDummyOrders(){
        orders = [
            Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
            Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
            Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date())
        ]
        
    }
    
    
    
}
