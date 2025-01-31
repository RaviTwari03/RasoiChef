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
            distance: 2.6,
            kitchenImage: "KitchenImage 1"
        ),
        Kitchen(
            kitchenID: "kitchen002",
            name: "Anjali’s Kitchen",
            location: "Sector 22, India",
            cuisines: [.SouthIndian, .Continental],
            rating: 4.6,
            isOnline: true,
            distance: 3.1,
            kitchenImage: "KitchenImage2"
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
            orderDeadline: "Order Before 6 am.",
            availability: [.Available]
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
            orderDeadline: "Order Before 11 am.",
            availability: [.Unavailable]
            
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
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available]
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
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available]
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
    
    static var globalChefSpecial: [GlobalChefSpeciality] = [
        GlobalChefSpeciality(
            kitchenName: "Flavors of Punjab",
            dishID: "special003",
            kitchenID: "kitchen003",
            name: "Butter Chicken",
            description: "Tender chicken cooked in a rich, creamy, and buttery tomato gravy.",
            price: 300.0,
            rating: 4.9,
            imageURL: "ButterChicken"
        ),
        GlobalChefSpeciality(
            kitchenName: "Mumbai Spices",
            dishID: "special004",
            kitchenID: "kitchen004",
            name: "Pav Bhaji",
            description: "A thick and spicy vegetable curry served with buttery bread rolls.",
            price: 150.0,
            rating: 4.5,
            imageURL: "PavBhaji"
        ),
        GlobalChefSpeciality(
            kitchenName: "Delhi Zaika",
            dishID: "special005",
            kitchenID: "kitchen005",
            name: "Rajma Chawal",
            description: "A comforting dish of red kidney beans cooked in spices and served with rice.",
            price: 180.0,
            rating: 4.6,
            imageURL: "RajmaChawal"
        ),
//        ChefSpecialtyDish(
//            kitchenName: "South Indian Delights",
//            dishID: "special006",
//            kitchenID: "kitchen006",
//            name: "Masala Dosa",
//            description: "A crispy dosa filled with spiced potato masala, served with chutneys.",
//            price: 120.0,
//            rating: 4.8,
//            imageURL: "MasalaDosa"
//        ),
        GlobalChefSpeciality(
            kitchenName: "Spice Aroma",
            dishID: "special007",
            kitchenID: "kitchen007",
            name: "Paneer Tikka",
            description: "Chunks of paneer marinated in spices and grilled to perfection.",
            price: 220.0,
            rating: 4.7,
            imageURL: "PaneerTikka"
        ),
        GlobalChefSpeciality(
            kitchenName: "Royal Rajasthan",
            dishID: "special008",
            kitchenID: "kitchen008",
            name: "Dal Baati Churma",
            description: "Traditional Rajasthani dish served with ghee-dipped baati and churma.",
            price: 250.0,
            rating: 4.9,
            imageURL: "DalBaatiChurma"
        ),
        GlobalChefSpeciality(
            kitchenName: "Biryani Bliss",
            dishID: "special009",
            kitchenID: "kitchen009",
            name: "Hyderabadi Biryani",
            description: "Aromatic and flavorful rice dish with tender pieces of chicken.",
            price: 350.0,
            rating: 4.8,
            imageURL: "HyderabadiBiryani"
        ),
        GlobalChefSpeciality(
            kitchenName: "Street Food Junction",
            dishID: "special010",
            kitchenID: "kitchen010",
            name: "Pani Puri",
            description: "Crispy puris filled with spicy, tangy tamarind water and potato filling.",
            price: 100.0,
            rating: 4.6,
            imageURL: "PaniPuri"
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
    
    // GlobalLunchMenu
    static var GloballunchMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item101",
            kitchenID: "kitchen002",
            name: "Paneer Butter Masala",
            description: "A creamy and delicious North Indian dish with tender paneer cubes cooked in a buttery tomato gravy.",
            price: 150.0,
            rating: 4.6,
            availableMealTypes: [.lunch],
            portionSize: "300 gm",
            intakeLimit: 15,
            imageURL: "PaneerButterMasala",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available]
            
        ),
        MenuItem(
            itemID: "item102",
            kitchenID: "kitchen003",
            name: "Chicken Biryani",
            description: "A flavorful and aromatic rice dish cooked with tender chicken pieces, spices, and saffron.",
            price: 180.0,
            rating: 4.7,
            availableMealTypes: [.lunch],
            portionSize: "400 gm",
            intakeLimit: 10,
            imageURL: "ChickenBiryani",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available]
        )
    ]

    // GlobalBreakfastMenu
    static var GlobalbreakfastMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item201",
            kitchenID: "kitchen004",
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato stuffing, served with coconut chutney and sambhar.",
            price: 50.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 20,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available]
        ),
        MenuItem(
            itemID: "item202",
            kitchenID: "kitchen005",
            name: "Pancakes with Honey",
            description: "Fluffy pancakes served with a drizzle of pure honey and a side of fresh fruits.",
            price: 90.0,
            rating: 4.3,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 25,
            imageURL: "PancakesHoney",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available]
        ),
        MenuItem(
            itemID: "item201",
            kitchenID: "kitchen004",
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato stuffing, served with coconut chutney and sambhar.",
            price: 50.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 20,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available]
        )
    ]

    // GlobalSnacksMenu
    static var GlobalsnacksMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item301",
            kitchenID: "kitchen006",
            name: "Samosa",
            description: "A crispy and flaky pastry filled with spiced potato and peas mixture, served with mint chutney.",
            price: 20.0,
            rating: 4.2,
            availableMealTypes: [.snacks],
            portionSize: "100 gm",
            intakeLimit: 50,
            imageURL: "Samosa",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available]
        ),
        MenuItem(
            itemID: "item302",
            kitchenID: "kitchen007",
            name: "Chicken Nuggets",
            description: "Crispy, golden-brown chicken nuggets served with tangy barbecue sauce.",
            price: 70.0,
            rating: 4.4,
            availableMealTypes: [.snacks],
            portionSize: "150 gm",
            intakeLimit: 30,
            imageURL: "ChickenNuggets",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available]
        )
    ]

    // GlobalDinnerMenu
    static var GlobaldinnerMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item401",
            kitchenID: "kitchen008",
            name: "Dal Tadka with Jeera Rice",
            description: "Classic Indian yellow dal tempered with ghee, spices, and served with fragrant cumin rice.",
            price: 120.0,
            rating: 4.6,
            availableMealTypes: [.dinner],
            portionSize: "350 gm",
            intakeLimit: 20,
            imageURL: "DalTadkaJeeraRice",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available]
        ),
        MenuItem(
            itemID: "item402",
            kitchenID: "kitchen009",
            name: "Grilled Salmon",
            description: "Perfectly grilled salmon fillet served with steamed vegetables and a lemon butter sauce.",
            price: 300.0,
            rating: 4.8,
            availableMealTypes: [.dinner],
            portionSize: "300 gm",
            intakeLimit: 8,
            imageURL: "GrilledSalmon",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available]
        )
    ]

    
    static var cartItems: [CartItem] = []
        

    static var orders: [Order] = []
    static var subscriptionPlans: [SubscriptionPlan] = []
    static var feedbacks: [Feedback] = []
    static var coupons: [Coupon] = []

   
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

    
//    static func updateCartItem(_ updatedCartItem: CartItem) {
//        if let index = cartItems.firstIndex(where: { $0.cartItemID == updatedCartItem.cartItemID }) {
//            cartItems[index] = updatedCartItem
//        }
//    }
//
//    static func deleteCartItem(byID cartItemID: String) {
//        cartItems.removeAll { $0.cartItemID == cartItemID }
//    }

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
        "Meal Categories",
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
             icon: "SnacksIcon"
         ),
         MealBanner(
             title: "Delightful Dinner",
             subtitle: "Order Before 7 pm",
             deliveryTime: "Delivery expected by 8 pm",
             timer: "25 min",
             icon: "DinnerIcon"
         )
     ]
    static var user : [User] = [
        User(
            userID: nil,
            name: nil,
            email: nil,
            phoneNumber: nil,
            address: "Galgotias University, Greater Noida"
            
        )
    ]
}

