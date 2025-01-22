//
//  Data Controller.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import Foundation


// MARK: - Data Controller

class KitchenDataController {
    static let shared = KitchenDataController()

    private init() {}

    // Static Data Stores
    static var users: [User] = []
    static var kitchens: [Kitchen] = [
        Kitchen(
            kitchenID: "kitchen001",
            name: "Kanha Ji Rasoi",
            location: "Sector 17A, India",
            cuisines: [.NorthIndian],
//            profileImageName: "Kitchen_Image",
            rating: 4.3,
            isOnline: true,
            distance: 2.6
        ),
        Kitchen(
            kitchenID: "kitchen002",
            name: "Anjali’s Kitchen",
            location: "Sector 22, India",
            cuisines: [.SouthIndian, .Continental],
            rating: 4.6,
            isOnline: true,
            distance: 3.1 
        )
    ]
    
    static var menuItems: [MenuItem] = [
        MenuItem(
            itemID: "item001",
            kitchenID: "kitchen001",
            name: "Vegetable Poha",
            description: "A light, nutritious dish made with flattened rice, salted veggies, and flavorful spices.",
            price: 70.0,
            rating: 4.1,
            availableMealTypes: [.breakfast],
            portionSize: "250 gm",
            intakeLimit: 20,
            imageURL: "VegetablePoha",
            orderDeadline: "Order Before 6 am."
        ),
        MenuItem(
            itemID: "item002",
            kitchenID: "kitchen001",
            name: "Veg Thali",
            description: "A hearty combo of Veg Soya Keema, Arhar Dal, Butter Rotis, Plain Rice, and Mix Veg.",
            price: 130.0,
            rating: 4.4,
            availableMealTypes: [.lunch],
            portionSize: "500 gm",
            intakeLimit: 15,
            imageURL: "VegThali",
            orderDeadline: "Order Before 11 am."
            
        ),
        MenuItem(
            itemID: "item003",
            kitchenID: "kitchen001",
            name: "Spring Roll",
            description: "Crispy rolls stuffed with spiced veggies, perfect for a delightful snack.",
            price: 50.0,
            rating: 4.3,
            availableMealTypes: [.snacks],
            portionSize: "6 pieces",
            intakeLimit: 10,
            imageURL: "SpringRoll",
            orderDeadline: "Order Before 3 pm."
        ),
        MenuItem(
            itemID: "item004",
            kitchenID: "kitchen002",
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato filling, served with chutneys and sambar.",
            price: 120.0,
            rating: 4.5,
            availableMealTypes: [.dinner],
            portionSize: "1 piece",
            intakeLimit: 25,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 7 pm."
        )
    ]
    
    static var chefSpecialtyDishes: [ChefSpecialtyDish] = [
            ChefSpecialtyDish(
                kitchenName: "Kanjha Ji Rasoi",
                dishID: "special001",
                kitchenID: "kitchen001",
                name: "Chole Bhature",
                description: "A creamy and rich tomato-based curry with soft paneer cubes.",
                price: 200.0,
                rating: 4.7,
                imageURL: "CholeBhature"
            ),
            ChefSpecialtyDish(
                kitchenName: "Anjali's Kitchen",
                dishID: "special002",
                kitchenID: "kitchen002",
                name: "Spring Roll",
                description: "A spicy and flavorful South Indian chicken curry.",
                price: 250.0,
                rating: 4.8,
                imageURL: "SpringRoll"
            )
        ]

//    struct SubscriptionPlan {
//        let planID: String
//        let userID: String // Foreign Key to User
//        let kitchenID: String // Foreign Key to Kitchen
//        var startDate: Date
//        var endDate: Date
//        var meals: [SubscriptionMeal]
//        var totalPrice: Double
//        var details: String // Details about the subscription (e.g., "Weekly Plan", "Customizable")
//        var mealCountPerDay: Int // Number of meals provided daily
//    }
    
    static var subscriptionPlan : [SubscriptionPlan] = [
        SubscriptionPlan(
            planID: "001",
            userID: "001",
            kitchenID: "kitchen001",
            startDate: nil ,
            endDate: nil,
            meals: [SubscriptionMeal(
                day: "Monday",
                mealType: .dinner,
                menuItemID: "menu001")
            ],
            totalPrice: nil,
            details: "Weekly Plan",
            mealCountPerDay: nil,
            planImage: "PlanImage"
        )
    ]
    
    static var cartItems: [CartItem] = []
//        CartItem(
//            userAdress: "Galgotias University, Plot No. 2, Yamuna Expy",
//            cartItemID: <#T##String#>,
////            userID: <#T##String#>,
//            menuItemID: <#T##String#>,
//            quantity: <#T##Int#>)
//    ]
    static var orders: [Order] = []
    static var subscriptionPlans: [SubscriptionPlan] = []
    static var feedbacks: [Feedback] = []
    static var coupons: [Coupon] = []

    // MARK: - CRUD Operations

    // User Management
    static func addUser(_ user: User) {
        users.append(user)
    }

    static func getUser(byID userID: String) -> User? {
        return users.first { $0.userID == userID }
    }

    static func updateUser(_ updatedUser: User) {
        if let index = users.firstIndex(where: { $0.userID == updatedUser.userID }) {
            users[index] = updatedUser
        }
    }

    static func deleteUser(byID userID: String) {
        users.removeAll { $0.userID == userID }
    }

    // Cart Management
    static func addCartItem(_ cartItem: CartItem) {
        cartItems.append(cartItem)
    }

    
    static func updateCartItem(_ updatedCartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.cartItemID == updatedCartItem.cartItemID }) {
            cartItems[index] = updatedCartItem
        }
    }

    static func deleteCartItem(byID cartItemID: String) {
        cartItems.removeAll { $0.cartItemID == cartItemID }
    }

    // Orders Management
    static func addOrder(_ order: Order) {
        orders.append(order)
    }

    static func getOrders(forUser userID: String) -> [Order] {
        return orders.filter { $0.userID == userID }
    }

    static func updateOrderStatus(orderID: String, status: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.orderID == orderID }) {
            orders[index].status = status
        }
    }

    static func deleteOrder(byID orderID: String) {
        orders.removeAll { $0.orderID == orderID }
    }
    static var sectionHeaderNames:[String] = [
        "Menu List",
        "Chef's Speciality Dishes",
        "Meal Subscription Plans"
    ]
    static var sectionHeaderLandingNames:[String] = [
        "Chef's Speciality Dishes",
        "Nearest Kitchens"
    ]

    static var dateItem : [DateItem] = [
        DateItem(date: 22,
                 dayOfWeek: "Wed",
                 month: "Jan",
                 isSelected: true,
                 isDisabled: false
                ),
        DateItem(date: 23,
                 dayOfWeek: "Thurs",
                 month: "Jan",
                 isSelected: true,
                 isDisabled: false
                ),
        DateItem(date: 24,
                 dayOfWeek: "Fri",
                 month: "Jan",
                 isSelected: true,
                 isDisabled: false
                ),
        DateItem(date: 25,
                 dayOfWeek: "Sat",
                 month: "Jan",
                 isSelected: true,
                 isDisabled: false
                ),
        DateItem(date: 26,
                 dayOfWeek: "Sun",
                 month: "Jan",
                 isSelected: true,
                 isDisabled: false
                ),
        DateItem(date: 27,
                 dayOfWeek: "Mon",
                 month: "Jan",
                 isSelected: true,
                 isDisabled: false
                )
    ]
    static var mealBanner : [MealBanner] =
    [MealBanner(
        title: "Taste the Noon Magic",
        subtitle: "Order Before 11 am",
        deliveryTime: "Delivery expected by 1 pm",
        timer: "10 min",
        icon: "LunchIcon"
    ),
    
         MealBanner(
             title: "Rise and Shine Breakfast",
             subtitle: "Order Before 8 am",
             deliveryTime: "Delivery expected by 9 am",
             timer: "20 min",
             icon: "BreakfastIcon"
         ),
         MealBanner(
             title: "Evening Snack Treat",
             subtitle: "Order Before 5 pm",
             deliveryTime: "Delivery expected by 6 pm",
             timer: "15 min",
             icon: "SnackIcon"
         ),
         MealBanner(
             title: "Delightful Dinner",
             subtitle: "Order Before 7 pm",
             deliveryTime: "Delivery expected by 8 pm",
             timer: "25 min",
             icon: "DinnerIcon"
         )
     ]
}
