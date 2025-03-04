//
//  OrderHistoryController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 27/02/25.
//

import Foundation

class OrderHistoryController {
    static var placedOrders: [OrderHistory] = []
    
    static func addOrder(_ order: OrderHistory) {
        placedOrders.append(order)
    }
}

struct OrderHistory {
    let orderID: String
    let items: [CartItem]
    let orderDate: Date
} 
