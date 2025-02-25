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
            kitchenImage: "KitchenImage 1",
            isPureVeg: false
        ),
        Kitchen(
            kitchenID: "kitchen002",
            name: "Anjali's Kitchen",
            location: "Sector 22, India",
            cuisines: [.SouthIndian, .Continental],
            rating: 4.6,
            isOnline: false,
            distance: 3.1,
            kitchenImage: "KitchenImage2",
            isPureVeg: false
        )
    ]
    
    static var menuItems: [MenuItem] = [
            MenuItem(
                itemID: "item001",
                kitchenID: "kitchen001",
                kitchenName: "Kanha Ji Rasoi",
                distance: 2.6,
                name: "Vegetable Poha",
                description: "A hearty combo of Veg Soya Keema, Arhar Dal, Butter Rotis, Plain Rice, and Mix Veg.",
                price: 70.0,
                rating: 4.1,
                availableMealTypes: [.breakfast],
                portionSize: "250 gm",
                intakeLimit: 20,
                imageURL: "VegetablePoha",
                orderDeadline: "Order Before 6 am.",
                recievingDeadline:"Delivery Expected by 8 am.",
                availability: [.Available],
                availableDays: [.monday, .tuesday],
                mealCategory: [.veg]
            ),
            MenuItem(
                itemID: "item002",
                kitchenID: "kitchen001",
                kitchenName: "Kanha Ji Rasoi",
                distance: 6.2,
                name: "Veg Thali",
                description: "A hearty combo of Veg Soya Keema, Arhar Dal, Butter Rotis, Plain Rice, and Mix Veg.",
                price: 130.0,
                rating: 4.4,
                availableMealTypes: [.lunch],
                portionSize: "500 gm",
                intakeLimit: 15,
                imageURL: "VegThali",
                orderDeadline: "Order Before 11 am.",
                recievingDeadline:"Delivery Expected by 1 pm.",
                availability: [.Unavailable],
                availableDays: [.monday,.wednesday,.sunday],
                mealCategory: [.veg]
                
            ),
            MenuItem(
                itemID: "item003",
                kitchenID: "kitchen001",
                kitchenName: "Kanha Ji Rasoi",
                distance: 3.9,
                availableDate: Date(),
                name: "Spring Roll",
                description: "Crispy rolls stuffed with spiced veggies, perfect for a delightful snack.",
                price: 50.0,
                rating: 4.3,
                availableMealTypes: [.snacks],
                portionSize: "6 pieces",
                intakeLimit: 10,
                imageURL: "SpringRoll",
                orderDeadline: "Order Before 3 pm.",
                recievingDeadline:"Delivery Expected by 5 pm.",
                availability: [.Available],
                availableDays: [.monday],
                mealCategory: [.veg]
            ),
            MenuItem(
                itemID: "item004",
                kitchenID: "kitchen002",
                kitchenName: "Kanha Ji Rasoi",
                distance: 7.3,
                name: "Masala Dosa",
                description: "A crispy rice pancake filled with spiced potato filling, served with chutneys and sambar.",
                price: 120.0,
                rating: 4.5,
                availableMealTypes: [.dinner],
                portionSize: "1 piece",
                intakeLimit: 25,
                imageURL: "MasalaDosa",
                orderDeadline: "Order Before 7 pm.",
                recievingDeadline:"Delivery Expected by 9 pm.",
                availability: [.Available],
                availableDays: [.monday],
                mealCategory: [.veg]
            ),
          ]
    static var subscriptionMenuItems: [MenuItem] = [
        // Breakfast Items
        MenuItem(
            itemID: "breakfast_1",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Masala Dosa",
            description: "Crispy rice crepe filled with spiced potato mixture, served with coconut chutney and sambar",
            price: 120.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "1 piece",
            intakeLimit: 20,
            imageURL: "MasalaDosa",
            orderDeadline: "Order before 7 AM",
            recievingDeadline: "Delivery by 8:30 AM",
            availability: [.Available],
            availableDays: [.monday, .wednesday, .friday],
            mealCategory: [.veg]
        ),
        
        MenuItem(
            itemID: "breakfast_2",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Aloo Paratha Thali",
            description: "Whole wheat flatbread stuffed with spiced potatoes, served with curd and pickle",
            price: 90.0,
            rating: 4.3,
            availableMealTypes: [.breakfast],
            portionSize: "2 pieces",
            intakeLimit: 25,
            imageURL: "AlooParatha",
            orderDeadline: "Order before 7 AM",
            recievingDeadline: "Delivery by 8:30 AM",
            availability: [.Available],
            availableDays: [.tuesday, .thursday, .saturday],
            mealCategory: [.veg]
        ),

        // Lunch Items
        MenuItem(
            itemID: "lunch_1",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Dal Makhani Thali",
            description: "Creamy black lentils, served with jeera rice, naan, and raita",
            price: 180.0,
            rating: 4.6,
            availableMealTypes: [.lunch],
            portionSize: "Full Thali",
            intakeLimit: 15,
            imageURL: "DalMakhani",
            orderDeadline: "Order before 11 AM",
            recievingDeadline: "Delivery by 12:30 PM",
            availability: [.Available],
            availableDays: [.monday, .wednesday, .friday],
            mealCategory: [.veg]
        ),

        // Snacks Items
        MenuItem(
            itemID: "snacks_1",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Samosa Platter",
            description: "Crispy pastry filled with spiced potatoes and peas, served with mint chutney",
            price: 60.0,
            rating: 4.4,
            availableMealTypes: [.snacks],
            portionSize: "2 pieces",
            intakeLimit: 30,
            imageURL: "Samosa",
            orderDeadline: "Order before 4 PM",
            recievingDeadline: "Delivery by 5 PM",
            availability: [.Available],
            availableDays: [.tuesday, .thursday, .saturday],
            mealCategory: [.veg]
        ),

        // Dinner Items
        MenuItem(
            itemID: "dinner_1",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Paneer Butter Masala",
            description: "Rich and creamy paneer curry served with butter naan and jeera rice",
            price: 220.0,
            rating: 4.7,
            availableMealTypes: [.dinner],
            portionSize: "Serves 1",
            intakeLimit: 20,
            imageURL: "PaneerButterMasala",
            orderDeadline: "Order before 8 PM",
            recievingDeadline: "Delivery by 9 PM",
            availability: [.Available],
            availableDays: [.monday, .wednesday, .friday],
            mealCategory: [.veg]
        ),

        // Additional Items with Different Day Combinations
        MenuItem(
            itemID: "breakfast_3",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Poha with Peanuts",
            description: "Flattened rice cooked with onions, peanuts, and spices",
            price: 70.0,
            rating: 4.2,
            availableMealTypes: [.breakfast],
            portionSize: "250g",
            intakeLimit: 25,
            imageURL: "VegetablePoha",
            orderDeadline: "Order before 7 AM",
            recievingDeadline: "Delivery by 8:30 AM",
            availability: [.Available],
            availableDays: [.sunday, .tuesday, .thursday],
            mealCategory: [.veg]
        ),

        MenuItem(
            itemID: "lunch_2",
            kitchenID: "kitchen001",
            kitchenName: "Kanha Ji Rasoi",
            distance: 2.6,
            name: "Chole Bhature",
            description: "Spiced chickpea curry served with deep-fried bread",
            price: 150.0,
            rating: 4.5,
            availableMealTypes: [.lunch],
            portionSize: "2 bhature",
            intakeLimit: 20,
            imageURL: "CholeBhature",
            orderDeadline: "Order before 11 AM",
            recievingDeadline: "Delivery by 12:30 PM",
            availability: [.Available],
            availableDays: [.tuesday, .thursday, .saturday, .sunday],
            mealCategory: [.veg]
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
            mealCategory: [.veg],
            distance: 2.6,
            intakeLimit: 11
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
            mealCategory: [.veg],
            distance: 3.1,
            intakeLimit: 11
        )
    ]
    
    static var globalChefSpecial: [ChefSpecialtyDish] = [
        ChefSpecialtyDish(
            kitchenName: "Flavors of Punjab",
            dishID: "special003",
            kitchenID: "kitchen003",
            name: "Butter Chicken",
            description: "Tender chicken cooked in a rich, creamy, and buttery tomato gravy.",
            price: 300.0,
            rating: 4.9,
            imageURL: "ButterChicken",
            mealCategory: [.nonVeg],
            distance: 4.3,
            intakeLimit: 11
        ),
        ChefSpecialtyDish(
            kitchenName: "Mumbai Spices",
            dishID: "special004",
            kitchenID: "kitchen004",
            name: "Pav Bhaji",
            description: "A thick and spicy vegetable curry served with buttery bread rolls.",
            price: 150.0,
            rating: 4.5,
            imageURL: "PavBhaji",
            mealCategory: [.veg],
            distance: 3.1,
            intakeLimit: 11
        ),
        ChefSpecialtyDish(
            kitchenName: "Delhi Zaika",
            dishID: "special005",
            kitchenID: "kitchen005",
            name: "Rajma Chawal",
            description: "A comforting dish of red kidney beans cooked in spices and served with rice.",
            price: 180.0,
            rating: 4.6,
            imageURL: "RajmaChawal",
            mealCategory: [.veg],
            distance: 2.5,
            intakeLimit: 11
        ),
     
        ChefSpecialtyDish(
            kitchenName: "Spice Aroma",
            dishID: "special007",
            kitchenID: "kitchen007",
            name: "Paneer Tikka",
            description: "Chunks of paneer marinated in spices and grilled to perfection.",
            price: 220.0,
            rating: 4.7,
            imageURL: "PaneerTikka",
            mealCategory: [.veg],
            distance: 1.7,
            intakeLimit: 11
        ),
        ChefSpecialtyDish(
            kitchenName: "Royal Rajasthan",
            dishID: "special008",
            kitchenID: "kitchen008",
            name: "Dal Baati Churma",
            description: "Traditional Rajasthani dish served with ghee-dipped baati and churma.",
            price: 250.0,
            rating: 4.9,
            imageURL: "DalBaatiChurma",
            mealCategory: [.veg],
            distance: 4.2,
            intakeLimit: 11
        ),
        ChefSpecialtyDish(
            kitchenName: "Biryani Bliss",
            dishID: "special009",
            kitchenID: "kitchen009",
            name: "Hyderabadi Biryani",
            description: "Aromatic and flavorful rice dish with tender pieces of chicken.",
            price: 350.0,
            rating: 4.8,
            imageURL: "HyderabadiBiryani",
            mealCategory: [.nonVeg],
            distance: 5.3,
            intakeLimit: 11
        ),
        ChefSpecialtyDish(
            kitchenName: "Street Food Junction",
            dishID: "special010",
            kitchenID: "kitchen010",
            name: "Pani Puri",
            description: "Crispy puris filled with spicy, tangy tamarind water and potato filling.",
            price: 100.0,
            rating: 4.6,
            imageURL: "PaniPuri",
            mealCategory: [.veg],
            distance: 2.9,
            intakeLimit: 11
        )
    ]
    
   
    static var subscriptionPlan: [SubscriptionPlan] = [
        SubscriptionPlan(
            planID: "001",
            userID: "001",
            kitchenID: "kitchen001",
            startDate: "2025-02-10",
            endDate: "2025-02-16",
            totalPrice: 1400,
            details: "Weekly Plan",
            PlanIntakeLimit: 4,
            planImage: "PlanImage",
            weeklyMeals: [
                .monday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item201" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item101" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item301" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item401" })
                ],
                .tuesday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item202" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item102" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item302" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item402" })
                ],
                .wednesday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item203" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item103" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item303" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item403" })
                ],
                .thursday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item204" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item104" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item304" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item404" })
                ],
                .friday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item205" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item105" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item305" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item405" })
                ],
                .saturday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item206" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item106" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item306" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item406" })
                ],
                .sunday: [
                    .breakfast: subscriptionMenuItems.first(where: { $0.itemID == "item207" }),
                    .lunch: subscriptionMenuItems.first(where: { $0.itemID == "item107" }),
                    .snacks: subscriptionMenuItems.first(where: { $0.itemID == "item307" }),
                    .dinner: subscriptionMenuItems.first(where: { $0.itemID == "item407" })
                ]
            ]
        )
    ]

    // GlobalLunchMenu
    static var GloballunchMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item101",
            kitchenID: "kitchen001",
            kitchenName: "Punjabi Rasoi",
            distance: 2.3,
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
            kitchenID: "kitchen002",
            kitchenName: "Shyam Rasoi ", distance: 3.5,
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
            itemID: "item103",
            kitchenID: "kitchen003",
            kitchenName: "Punjabi Di Hatti", distance: 2.6,
            name: "Veg Thali",
            description: "A wholesome and flavorful meal featuring a variety of dishes, including dal, sabzi, rice, roti, and sides like pickle and salad",
            price: 150.0,
            rating: 2.6,
            availableMealTypes: [.lunch],
            portionSize: "300 gm",
            intakeLimit: 10,
            imageURL: "VegThali",
            orderDeadline: "Order Before 11 am.",
            availability: [.Available],
            availableDays: [.friday],
            mealCategory: [.veg]

            
        ),
        MenuItem(
            itemID: "item104",
            kitchenID: "kitchen004",
            kitchenName: "Shyam Rasoi ", distance: 4.6,
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
            kitchenID: "kitchen005",
            kitchenName: "Dosa Station", distance: 3.5,
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato stuffing, served with coconut chutney and sambhar.",
            price: 50.0,
            rating: 4.5,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 8,
            imageURL: "MasalaDosa",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item202",
            kitchenID: "kitchen006",
            kitchenName: "Rohan Fast Food", distance: 4.2,
            name: "Pav Bhaji",
            description: "A spicy, buttery mashed vegetable curry (bhaji) served with soft, toasted pav buns.",
            price: 110.0,
            rating: 4.3,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 5,
            imageURL: "PavBhaji",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item203",
            kitchenID: "kitchen007",
            kitchenName: "North Indian ", distance: 1.3,
            name: "Vegetable Poha",
            description: "A freshly prepared poha with organic Veggies.",
            price: 120.0,
            rating: 3.5,
            availableMealTypes: [.breakfast],
            portionSize: "200 gm",
            intakeLimit: 10,
            imageURL: "VegetablePoha",
            orderDeadline: "Order Before 6 am.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
            ),
        
        MenuItem(
            itemID: "item204",
            kitchenID: "kitchen008",
            kitchenName: "South Indian Junction", distance: 3.3,
            name: "Masala Dosa",
            description: "A crispy rice pancake filled with spiced potato stuffing, served with coconut chutney and sambhar.",
            price: 70.0,
            rating: 5.0,
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
            kitchenID: "kitchen009",
            kitchenName: "Ram Fast Food", distance: 3.6,
            name: "Spring Roll",
            description: "Crispy, golden rolls filled with a delicious mix of fresh veggies and aromatic spices. Served with a tangy dip for the perfect crunchy bite!",
            price: 80.0,
            rating: 4.9,
            availableMealTypes: [.snacks],
            portionSize: "100 gm",
            intakeLimit: 25,
            imageURL: "SpringRoll",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item302",
            kitchenID: "kitchen010",
            kitchenName: "Chawla Fast Food", distance: 1.7,
            name: "Pani Puri",
            description: "Crispy, hollow puris filled with spicy, tangy, and flavorful water, paired with a tasty potato and chickpea filling. A perfect burst of flavors in every bite!",
            price: 70.0,
            rating: 4.4,
            availableMealTypes: [.snacks],
            portionSize: "150 gm",
            intakeLimit: 30,
            imageURL: "PaniPuri",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item303",
            kitchenID: "kitchen011",
            kitchenName: "North Indian ", distance: 1.3,
            name: "Vegetable Poha",
            description: "A freshly prepared poha with organic Veggies.",
            price: 120.0,
            rating: 3.5,
            availableMealTypes: [.snacks],
            portionSize: "200 gm",
            intakeLimit: 10,
            imageURL: "VegetablePoha",
            orderDeadline: "Order Before 3 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
            ),
        MenuItem(
            itemID: "item304",
            kitchenID: "kitchen012",
            kitchenName: "Rohan Fast Food", distance: 4.2,
            name: "Pav Bhaji",
            description: "A spicy, buttery mashed vegetable curry (bhaji) served with soft, toasted pav buns.",
            price: 110.0,
            rating: 4.3,
            availableMealTypes: [.snacks],
            portionSize: "200 gm",
            intakeLimit: 5,
            imageURL: "PavBhaji",
            orderDeadline: "Order Before 4 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        )
    ]

    // GlobalDinnerMenu
    static var GlobaldinnerMenuItems: [MenuItem] = [
        MenuItem(
            itemID: "item401",
            kitchenID: "kitchen013",
            kitchenName: "Marwadi rasoi", distance: 2.4,
            name: "Dal Baati Churma",
            description: "A traditional Rajasthani delicacy featuring crispy, ghee-soaked baatis served with flavorful dal and sweet churma.",
            price: 100.0,
            rating: 5.0,
            availableMealTypes: [.dinner],
            portionSize: "350 gm",
            intakeLimit: 20,
            imageURL: "DalBaatiChurma",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item402",
            kitchenID: "kitchen014",
            kitchenName: "Fast Food Junction", distance: 1.2,
            name: "Hyderabadi Biryani",
            description: " A fragrant and flavorful rice dish made with aromatic basmati rice, tender marinated vegetables, and a rich blend of spices, slow-cooked to perfection.",
            price: 300.0,
            rating: 4.8,
            availableMealTypes: [.dinner],
            portionSize: "300 gm",
            intakeLimit: 5,
            imageURL: "HyderabadiBiryani",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.nonVeg]
        ),
        MenuItem(
            itemID: "item403",
            kitchenID: "kitchen015",
            kitchenName: "North Indian Food Junction", distance: 5.3,
            name: "Rajma Chawal",
            description: " A comforting North Indian dish featuring red kidney beans cooked in a flavorful tomato-based gravy, served with steamed rice for a wholesome and hearty meal.",
            price: 140.0,
            rating: 4.8,
            availableMealTypes: [.dinner],
            portionSize: "300 gm",
            intakeLimit: 18,
            imageURL: "RajmaChawal",
            orderDeadline: "Order Before 7 pm.",
            availability: [.Available],
            availableDays: [.monday],
            mealCategory: [.veg]
        ),
        MenuItem(
            itemID: "item404",
            kitchenID: "kitchen016",
            kitchenName: "Punjabi Food Junction", distance: 0.2,
            name: "Paneer Tikka",
            description: " A creamy and delicious North Indian dish with tender paneer cubes cooked in a buttery tomato gravy.",
            price: 100.0,
            rating: 4.8,
            availableMealTypes: [.dinner],
            portionSize: "300 gm",
            intakeLimit: 10,
            imageURL: "PaneerTikka",
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

    
    static var mealBanner : [MealBanner] =
    [MealBanner(
        title: "Rise and Shine Breakfast",
        subtitle: "Order Before 7 am",
        deliveryTime: "Delivery expected by 9 am",
        timer: "00 min",
        icon: "BreakfastIcon",
        mealType: "Breakfast"
    ),
    
         MealBanner(
             title: "Taste the Noon Magic",
             subtitle: "Order Before 11 am",
             deliveryTime: "Delivery expected by 1 pm",
             timer: "00 min",
             icon: "LunchIcon",
             mealType: "Lunch"
         ),
         MealBanner(
             title: "Evening Snack Treat",
             subtitle: "Order Before 4 pm",
             deliveryTime: "Delivery expected by 6 pm",
             timer: "00 min",
             icon: "SnacksIcon",
             mealType: "Snacks"
         ),
         MealBanner(
             title: "Delightful Dinner",
             subtitle: "Order Before 8 pm",
             deliveryTime: "Delivery expected by 10 pm",
             timer: "00 min",
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

