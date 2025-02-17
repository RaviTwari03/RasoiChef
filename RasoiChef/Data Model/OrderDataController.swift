//
//  OrderDataController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation
import UIKit

class OrderDataController{
    // Current order data controller
    private var orders: [Order] = []

    static var shared = OrderDataController()

    // Get all orders
    func getOrders() -> [Order] {
        return orders
    }

    // Get order count
    func getOrderCount() -> Int {
        return orders.count
    }

    // Add a new order
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

    // Get count of active orders (placed or delivered)
    func getActiveOrdersCount() -> Int {
        return orders.filter { $0.status == .placed || $0.status == .delivered }.count
    }

    // Load dummy orders (currently empty)
    func loadDummyOrders() {
        // Dummy orders with different statuses
        orders = []

        sortOrdersByStatus()  // Ensure the orders are categorized correctly into current and past orders
    }
    
    
    // subscription plan data controller
    
    
    private var SubscriptionPlans: [SubscriptionPlan] = []

  

        
        
    }
    
    
    

