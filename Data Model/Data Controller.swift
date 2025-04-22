//
//  Data Controller.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import Foundation

class KitchenDataController {
    static let shared = KitchenDataController()
    
    private init() {}
    
    // MARK: - Data Storage
    static var users: [User] = []
    static var kitchens: [Kitchen] = []
    static var filteredKitchens: [Kitchen] = [] // For filtered kitchen view
    static var menuItems: [MenuItem] = []
    static var filteredMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var subscriptionMenuItems: [MenuItem] = []
    static var chefSpecialtyDishes: [ChefSpecialtyDish] = []
    static var filteredChefSpecialtyDishes: [ChefSpecialtyDish] = [] // For kitchen-specific view
    static var globalChefSpecial: [ChefSpecialtyDish] = []
    static var subscriptionPlan: [SubscriptionPlan] = []
    static var filteredSubscriptionPlan: [SubscriptionPlan] = [] // For kitchen-specific view
    static var GloballunchMenuItems: [MenuItem] = []
    static var GlobalbreakfastMenuItems: [MenuItem] = []
    static var GlobalsnacksMenuItems: [MenuItem] = []
    static var GlobaldinnerMenuItems: [MenuItem] = []
    static var filteredLunchMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var filteredBreakfastMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var filteredSnacksMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var filteredDinnerMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var cartItems: [CartItem] = []
    static var orders: [Order] = []
    static var subscriptionPlans: [SubscriptionPlan] = []
    static var feedbacks: [Feedback] = []
    static var coupons: [Coupon] = []

    // MARK: - Data Loading
    
    static func loadData() async throws {
        // ... existing code ...
    }

    // MARK: - Kitchen-Specific Data
    
    static func loadKitchenSpecificData(forKitchenID kitchenID: String) {
        // Filter kitchens for this specific kitchen
        filteredKitchens = kitchens.filter { $0.kitchenID == kitchenID }
        
        // Filter menu items for this kitchen
        filteredMenuItems = getKitchenMenuItems(forKitchenID: kitchenID)
        
        // Filter and update meal type specific arrays
        filteredBreakfastMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .breakfast }
        filteredLunchMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .lunch }
        filteredSnacksMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .snacks }
        filteredDinnerMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .dinner }
        
        // Filter chef specialty dishes for this kitchen
        filteredChefSpecialtyDishes = getKitchenChefSpecialtyDishes(forKitchenID: kitchenID)
        
        // Filter subscription plans for this kitchen
        filteredSubscriptionPlan = getKitchenSubscriptionPlans(forKitchenID: kitchenID)
    }
    
    // ... rest of existing code ...
} 