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
            kitchenName: "Kanha Ji Rasoi",
            name: "Vegetable Poha",
            description: "A light, nutritious dish made with flattened rice, salted veggies, and flavorful spices.",
            price: 70.0,
            rating: 4.1,
            availableMealTypes: [.breakfast],
            portionSize: "250 gm",
            intakeLimit: 20,
            imageURL: "VegetablePoha",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item002",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Veg Thali",
            description: "A hearty combo of Veg Soya Keema, Arhar Dal, Butter Rotis, Plain Rice, and Mix Veg.",
            price: 130.0,
            rating: 4.4,
            availableMealTypes: [.lunch],
            portionSize: "500 gm",
            intakeLimit: 15,
            imageURL: "VegThali",
            orderDeadline: "Order Before 11 am.",
            availability: [.Unavailable],
            availableDays: [.monday],
            mealCategory: [.veg]
            
        ),
        MenuItem(
            itemID: "item003",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Spring Roll",
            description: "Crispy rolls stuffed with spiced veggies, perfect for a delightful snack.",
            price: 50.0,
            rating: 4.3,
            availableMealTypes: [.snacks],
            portionSize: "6 pieces",
            intakeLimit: 10,
            imageURL: "SpringRoll",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item004",
            kitchenID: "kitchen002",
            kitchenName: "Kanha Ji Rasoi",
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato filling, served with chutneys and sambar.",
            price: 120.0,
            rating: 4.5,
            availableMealTypes: [.dinner],
            portionSize: "1 piece",
            intakeLimit: 25,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        //subscription menu
        MenuItem(
            itemID: "item201",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Pancakes with Honey",
            description: "Soft and fluffy pancakes served with organic honey.",
            price: 100.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "300 gm",
            intakeLimit: 15,
            imageURL: "PancakesHoney",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item202",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Oats & Fruits Bowl",
            description: "Healthy oats mixed with fresh seasonal fruits.",
            price: 120.0,
            rating: 4.3,
            availableMealTypes: [.breakfast],
            portionSize: "250 gm",
            intakeLimit: 10,
            imageURL: "OatsFruitsBowl",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.tuesday, .thursday, .saturday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item203",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Poha with Peanuts",
            description: "Light and nutritious poha garnished with peanuts.",
            price: 90.0,
            rating: 4.0,
            availableMealTypes: [.breakfast],
            portionSize: "250 gm",
            intakeLimit: 20,
            imageURL: "PohaPeanuts",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.wednesday, .friday, .sunday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item101",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Paneer Butter Masala with Roti",
            description: "Rich and creamy paneer butter masala with soft rotis.",
            price: 180.0,
            rating: 4.6,
            availableMealTypes: [.lunch],
            portionSize: "400 gm",
            intakeLimit: 25,
            imageURL: "PaneerButterMasala",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available],
            availableDays: [.monday, .wednesday, .friday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item401",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Shahi Paneer with Naan",
            description: "Rich and creamy shahi paneer served with naan.",
            price: 210.0,
            rating: 4.7,
            availableMealTypes: [.dinner],
            portionSize: "350 gm",
            intakeLimit: 20,
            imageURL: "ShahiPaneer",
            orderDeadline: "Order Before 6 pm.",
            availability: [.Available],
            availableDays: [.monday, .thursday, .saturday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item404",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            name: "Fish Curry with Roti",
            description: "Spicy and tangy fish curry served with fresh rotis.",
            price: 220.0,
            rating: 4.3,
            availableMealTypes: [.dinner],
            portionSize: "350 gm",
            intakeLimit: 15,
            imageURL: "FishCurry",
            orderDeadline: "Order Before 6 pm.",
            availability: [.Available],
            availableDays: [.friday, .sunday],
            mealCategory: [.nonVeg]
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
                imageURL: "CholeBhature",
                mealCategory: [.veg]
            ),
            ChefSpecialtyDish(
                kitchenName: "Anjali's Kitchen",
                dishID: "special002",
                kitchenID: "kitchen002",
                name: "Spring Roll",
                description: "A spicy and flavorful South Indian chicken curry.",
                price: 250.0,
                rating: 4.8,
                imageURL: "SpringRoll",
                mealCategory: [.veg]
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
            imageURL: "ButterChicken",
            mealCategory: [.nonVeg]
        ),
        GlobalChefSpeciality(
            kitchenName: "Mumbai Spices",
            dishID: "special004",
            kitchenID: "kitchen004",
            name: "Pav Bhaji",
            description: "A thick and spicy vegetable curry served with buttery bread rolls.",
            price: 150.0,
            rating: 4.5,
            imageURL: "PavBhaji",
            mealCategory: [.veg]
        ),
        GlobalChefSpeciality(
            kitchenName: "Delhi Zaika",
            dishID: "special005",
            kitchenID: "kitchen005",
            name: "Rajma Chawal",
            description: "A comforting dish of red kidney beans cooked in spices and served with rice.",
            price: 180.0,
            rating: 4.6,
            imageURL: "RajmaChawal",
            mealCategory: [.veg]
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
            imageURL: "PaneerTikka",
            mealCategory: [.veg]
        ),
        GlobalChefSpeciality(
            kitchenName: "Royal Rajasthan",
            dishID: "special008",
            kitchenID: "kitchen008",
            name: "Dal Baati Churma",
            description: "Traditional Rajasthani dish served with ghee-dipped baati and churma.",
            price: 250.0,
            rating: 4.9,
            imageURL: "DalBaatiChurma",
            mealCategory: [.veg]
        ),
        GlobalChefSpeciality(
            kitchenName: "Biryani Bliss",
            dishID: "special009",
            kitchenID: "kitchen009",
            name: "Hyderabadi Biryani",
            description: "Aromatic and flavorful rice dish with tender pieces of chicken.",
            price: 350.0,
            rating: 4.8,
            imageURL: "HyderabadiBiryani",
            mealCategory: [.veg]
        ),
        GlobalChefSpeciality(
            kitchenName: "Street Food Junction",
            dishID: "special010",
            kitchenID: "kitchen010",
            name: "Pani Puri",
            description: "Crispy puris filled with spicy, tangy tamarind water and potato filling.",
            price: 100.0,
            rating: 4.6,
            imageURL: "PaniPuri",
            mealCategory: [.veg]
        )
    ]

//    static var subscriptionPlan: [SubscriptionPlan] = [
//        SubscriptionPlan(
//            planID: "001",
//            userID: "001",
//            kitchenID: "kitchen001",
//            startDate: "2025-02-10",
//            endDate: "2025-02-16",
//            totalPrice: 1400.0,
//            details: "Weekly Plan",
//            mealCountPerDay: 4,
//            planImage: "PlanImage",
//            weeklyMeals: [
//                .monday: [.breakfast: menuItems.first(where: { $0.itemID == "item201" }),.lunch: "item101", .snacks: "item301", .dinner: "menu001"],
//                .tuesday: [.breakfast: "item202", .lunch: "item102", .snacks: "item302", .dinner: "item401"],
//                .wednesday: [.breakfast: "item203", .lunch: "item103", .snacks: "item303", .dinner: "item402"],
//                .thursday: [.breakfast: "item204", .lunch: "item104", .snacks: "item304", .dinner: "item403"],
//                .friday: [.breakfast: "item205", .lunch: "item105", .snacks: "item305", .dinner: "item404"],
//                .saturday: [.breakfast: "item206", .lunch: "item106", .snacks: "item306", .dinner: "item405"],
//                .sunday: [.breakfast: "item207", .lunch: "item107", .snacks: "item307", .dinner: "item406"]
//            ]
//        )
//    ]
   

    static var subscriptionPlan: [SubscriptionPlan] = [
        SubscriptionPlan(
            planID: "001",
            userID: "001",
            kitchenID: "kitchen001",
            startDate: "2025-02-10",
            endDate: "2025-02-16",
            totalPrice: 1400.0,
            details: "Weekly Plan",
            mealCountPerDay: 4,
            planImage: "PlanImage",
            weeklyMeals: [
                .monday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item201" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item101" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item301" }),
                    .dinner: menuItems.first(where: { $0.itemID == "menu001" })
                ],
                .tuesday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item202" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item102" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item302" }),
                    .dinner: menuItems.first(where: { $0.itemID == "item401" })
                ],
                .wednesday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item203" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item103" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item303" }),
                    .dinner: menuItems.first(where: { $0.itemID == "item402" })
                ],
                .thursday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item204" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item104" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item304" }),
                    .dinner: menuItems.first(where: { $0.itemID == "item403" })
                ],
                .friday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item205" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item105" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item305" }),
                    .dinner: menuItems.first(where: { $0.itemID == "item404" })
                ],
                .saturday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item206" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item106" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item306" }),
                    .dinner: menuItems.first(where: { $0.itemID == "item405" })
                ],
                .sunday: [
                    .breakfast: menuItems.first(where: { $0.itemID == "item207" }),
                    .lunch: menuItems.first(where: { $0.itemID == "item107" }),
                    .snacks: menuItems.first(where: { $0.itemID == "item307" }),
                    .dinner: menuItems.first(where: { $0.itemID == "item406" })
                ]
            ]
        )
    ]


    
    // GlobalLunchMenu
    static var GloballunchMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item101",
            kitchenID: "kitchen002",
            kitchenName: "Punjabi Rasoi",
            name: "Paneer Masala",
            description: "A creamy and delicious North Indian dish with tender paneer cubes cooked in a buttery tomato gravy.",
            price: 150.0,
            rating: 4.6,
            availableMealTypes: [.lunch],
            portionSize: "300 gm",
            intakeLimit: 15,
            imageURL: "PaneerTikka",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
            
        ),
        MenuItem(
            itemID: "item102",
            kitchenID: "kitchen003",
            kitchenName: "Shyam Rasoi ",
            name: "Rajma Chawal",
            description: "A flavorful and aromatic Rajma dish,  cooked with  spices, and tomato-based gravy",
            price: 180.0,
            rating: 4.7,
            availableMealTypes: [.lunch],
            portionSize: "400 gm",
            intakeLimit: 10,
            imageURL: "RajmaChawal",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available],
            availableDays: [.friday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item104",
            kitchenID: "kitchen004",
            kitchenName: "Punjabi Rasoi",
            name: "Paneer Masala",
            description: "A creamy and delicious North Indian dish with tender paneer cubes cooked in a buttery tomato gravy.",
            price: 150.0,
            rating: 4.6,
            availableMealTypes: [.lunch],
            portionSize: "300 gm",
            intakeLimit: 15,
            imageURL: "PaneerTikka",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available],
            availableDays: [.friday],
            mealCategory: [.veg]

            
        ),
        MenuItem(
            itemID: "item102",
            kitchenID: "kitchen003",
            kitchenName: "Shyam Rasoi ",
            name: "Rajma Chawal",
            description: "A flavorful and aromatic Rajma dish,  cooked with  spices, and tomato-based gravy",
            price: 180.0,
            rating: 4.7,
            availableMealTypes: [.lunch],
            portionSize: "400 gm",
            intakeLimit: 10,
            imageURL: "RajmaChawal",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        )
    ]
    

    // GlobalBreakfastMenu
    static var GlobalbreakfastMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item201",
            kitchenID: "kitchen004",
            kitchenName: "Dosa Station",
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato stuffing, served with coconut chutney and sambhar.",
            price: 50.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 20,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item202",
            kitchenID: "kitchen005",
            kitchenName: "Rohan Fast Food",
            name: "Pancakes with Honey",
            description: "Fluffy pancakes served with a drizzle of pure honey and a side of fresh fruits.",
            price: 90.0,
            rating: 4.3,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 25,
            imageURL: "PancakesHoney",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item201",
            kitchenID: "kitchen004",
            kitchenName: "South Indian Junction",
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato stuffing, served with coconut chutney and sambhar.",
            price: 50.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 20,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        )
    ]

    // GlobalSnacksMenu
    static var GlobalsnacksMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item301",
            kitchenID: "kitchen006",
            kitchenName: "Ram Fast Food",
            name: "Samosa",
            description: "A crispy and flaky pastry filled with spiced potato and peas mixture, served with mint chutney.",
            price: 20.0,
            rating: 4.2,
            availableMealTypes: [.snacks],
            portionSize: "100 gm",
            intakeLimit: 50,
            imageURL: "Samosa",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item302",
            kitchenID: "kitchen007",
            kitchenName: "Abdul Fast Food",
            name: "Chicken Nuggets",
            description: "Crispy, golden-brown chicken nuggets served with tangy barbecue sauce.",
            price: 70.0,
            rating: 4.4,
            availableMealTypes: [.snacks],
            portionSize: "150 gm",
            intakeLimit: 30,
            imageURL: "ChickenNuggets",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        )
    ]

    // GlobalDinnerMenu
    static var GlobaldinnerMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item401",
            kitchenID: "kitchen008",
            kitchenName: "Krishna rasoi",
            name: "Dal Tadka with Jeera Rice",
            description: "Classic Indian yellow dal tempered with ghee, spices, and served with fragrant cumin rice.",
            price: 120.0,
            rating: 4.6,
            availableMealTypes: [.dinner],
            portionSize: "350 gm",
            intakeLimit: 20,
            imageURL: "DalTadkaJeeraRice",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item402",
            kitchenID: "kitchen009",
            kitchenName: "Fast Food Junction",
            name: "Grilled Salmon",
            description: "Perfectly grilled salmon fillet served with steamed vegetables and a lemon butter sauce.",
            price: 300.0,
            rating: 4.8,
            availableMealTypes: [.dinner],
            portionSize: "300 gm",
            intakeLimit: 8,
            imageURL: "GrilledSalmon",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
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
        "Chef's Speciality",
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
        title: "Rise and Shine Breakfast",
        subtitle: "Order Before 6 am",
        deliveryTime: "Delivery expected by 9 am",
        timer: "20 min",
        icon: "BreakfastIcon",
        mealType: "Breakfast"
    ),
    
         MealBanner(
             title: "Taste the Noon Magic",
             subtitle: "Order Before 11 am",
             deliveryTime: "Delivery expected by 1 pm",
             timer: "10 min",
             icon: "LunchIcon",
             mealType: "Lunch"
         ),
         MealBanner(
             title: "Evening Snack Treat",
             subtitle: "Order Before 4 pm",
             deliveryTime: "Delivery expected by 6 pm",
             timer: "15 min",
             icon: "SnacksIcon",
             mealType: "Snacks"
         ),
         MealBanner(
             title: "Delightful Dinner",
             subtitle: "Order Before 7 pm",
             deliveryTime: "Delivery expected by 9 pm",
             timer: "25 min",
             icon: "DinnerIcon",
             mealType: "Dinner"
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

