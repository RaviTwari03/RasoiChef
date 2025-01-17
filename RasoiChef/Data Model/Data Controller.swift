//
//  Data Controller.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import Foundation

class KitchenDataController {
    static let shared = KitchenDataController()

    static var restaurantInfo: RestaurantInfo = RestaurantInfo(
        name: "Kanha Ji Rasoi",
        distance: "2.1 km Greater Noida",
        cuisine: .nortIndian,
        rating: 4.1,
        imageNames: ["kitchen_image"]
    )

    static var menuSections: [MenuSection] = [
        MenuSection(
            sectionName: .breakfast,
            sectionIcon: .breakfastIcon,
            orderDeadline: "Order Before 6 am",
            deliveryTime: "Delivery Expected By 8 am",
            meals: [
                Meal(
                    name: "Vegetable Poha",
                    price: 70.0,
                    rating: 4.1,
                    image: "poha_image",
                    availability: .available,
                    foodType: .vegetarian,
                    description: "A light and delicious breakfast option",
                    intakeLimit: 10
                )
            ]
        ),
        MenuSection(
            sectionName: .lunch,
            sectionIcon: .lunchIcon,
            orderDeadline: "Order Before 1 pm",
            deliveryTime: "Delivery Expected By 2 pm",
            meals: [
                Meal(
                    name: "Veg Thali",
                    price: 130.0,
                    rating: 4.4,
                    image: "veg_thali_image",
                    availability: .available,
                    foodType: .vegetarian,
                    description: "A wholesome lunch with balanced flavors",
                    intakeLimit: 15
                )
            ]
        )
    ]

    static var chefsSpecialDishes: [ChefsSpecial] = [
        ChefsSpecial(
            name: "Kadai Paneer",
            price: 180.0,
            rating: 4.6,
            image: "kadai_paneer_image",
            intakeLimit: 5,
            availabilityDays: [.monday, .wednesday, .friday],
            availabilityTimes: [.lunch, .dinner]
        ),
        ChefsSpecial(
            name: "Chole Bhature",
            price: 150.0,
            rating: 4.5,
            image: "chole_bhature_image",
            intakeLimit: 8,
            availabilityDays: [.sunday, .saturday],
            availabilityTimes: [.breakfast, .lunch]
        )
    ]

    static var nearestKitchens: [Kitchen] = [
        Kitchen(
            name: "Kanha Ji Rasoi",
            image: "kanha_ji_rasoi_image",
            cuisineType: .nortIndian,
            distanceInKm: 2.6,
            rating: 4.1,
            availabilityStatus: .online,
            foodType: .vegetarian
        ),
        Kitchen(
            name: "Shyam Bhojnalaya",
            image: "shyam_bhojnalaya_image",
            cuisineType: .southIndian,
            distanceInKm: 3.2,
            rating: 4.3,
            availabilityStatus: .online,
            foodType: .vegetarian
        )
    ]

    static var sectionHeaderNames: SectionHeaderNames = SectionHeaderNames(
        menu: "Meal Categories",
        special: "Chef’s Speciality Dishes",
        subscription: "Nearest Kitchens"
    )
}
