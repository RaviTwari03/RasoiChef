//
//  OrderDataController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation

class OrderDataController{
    private var orders:[Order] = []
    private var pastOrders:[Order] = []
    
    private init(){
        loadDummyOrders()
        pastOrdersdummyData()
    }
    
    static var shared = OrderDataController()
    static var sharedPastOrders = OrderDataController()
    
    func getOrderCount() -> Int {
        return orders.count
    }
    func getPastOrderCount() -> Int {
        return pastOrders.count
    }
    
    func loadDummyOrders(){
        orders = [
            Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
            Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
           
        ]
        
    }
     func pastOrdersdummyData(){
        pastOrders = [
            Order(orderID: UUID(), orderNumber: "Order 1", homecook: HomeCook(name: "Kanha Ji Rasoi"), items: [Meal(name: "Rajma Chawal")], date: Date()),
            Order(orderID: UUID(), orderNumber: "order 2", homecook: HomeCook(name: "Rana Ji Rasoi"), items: [Meal(name: "Paneer")], date: Date())]
            }
    }
    
    
    
            
