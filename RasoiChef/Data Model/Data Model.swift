//
//  Data Model.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import Foundation



// MARK: - Complete Data Model

// Main Restaurant Screen Model
struct MainScreenModel {
    let location: String
    let restaurantInfo: RestaurantInfo
//    let menuSections: [MenuSection]
    let chefsSpecialDishes: [ChefsSpecial]
    let nearestKitchens: [Kitchen]
//    let subscriptionPlans: [SubscriptionPlan]
}

// MARK: - Restaurant Information Model
struct RestaurantInfo {
    let name: String
    let distance: String
    let cuisine: CuisineType
    let rating: Double
    let imageNames: [String]
}

// MARK: - Menu Section Model
struct MenuSection {
    let sectionName: SectionName
    let sectionIcon: SectionIcon
    let orderDeadline: String
    let deliveryTime: String
    let meals: [Meal]
}

// Enum for Section Names
enum SectionName: String {
    case breakfast = "Breakfast 🌅"
    case lunch = "Lunch ☀️"
    case dinner = "Dinner 🌕"
    case snacks = "Snacks "
    
}

// Enum for Section Icons
enum SectionIcon: String {
    case breakfastIcon = "sunrise"
    case lunchIcon = "sun"
    case dinnerIcon = "moon"
    case snacksIcon = "snack"
    
}


// MARK: - Meal Model
struct Meal {
    let name: String
    let price: Double
    let rating: Double
    let image: String
    let availability: MealAvailability
    let foodType: FoodType
    let description : String
    let intakeLimit: Int
    
}

// MARK: - Chef’s Special Dishes Model
struct ChefsSpecial {
    let name: String
    let price: Double
    let rating: Double
    let image: String
    let intakeLimit: Int
    let availabilityDays: [Day]
    let availabilityTimes: [SectionName]
}

// MARK: - Nearest Kitchen Model
struct Kitchen {
    let name: String
    let image: String
    let cuisineType: CuisineType
    let distanceInKm: Double
    let rating: Double
    let availabilityStatus: AvailabilityStatus
    let foodType: FoodType
//    let timings: [MealTiming]
}

// MARK: - Subscription Plan Model
struct SubscriptionPlan {
    let name: String
    let intakeLimit: Int
    let availableDays: [Day]
    let availableTimes: [TimeSlot]
    let image: String
}

// MARK: - Header Names for Sections
struct SectionHeaderNames {
    let menu: String
    let special: String
    let subscription: String
}

// MARK: - Enums

// Cuisine Types
enum CuisineType: String {
    case indian = "Indian"
    case nortIndian = "North Indian"
    case southIndian = "South Indian"
    case bengali = "Bengali"
    case eastIndian = "East Indian"
    case westIndian = "West Indian"
}
//enum NorthIndian{
//    case punjabi = "Punjabi"
//    case rajasthan = "Rajasthani"
//}

// Food Type
enum FoodType: String {
    case vegetarian = "Vegetarian"
    case nonVegetarian = "Non-Vegetarian"
}

// Meal Availability Status
enum MealAvailability: String {
    case available = "Available"
    case notAvailable = "Not Available"
}

// Availability Days
enum Day: String {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

// Availability Times
enum TimeSlot: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}

// Meal Timings for Kitchens
enum MealTiming: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}

// Kitchen Availability Status
enum AvailabilityStatus: String {
    case online = "Online"
    case offline = "Offline"
}


struct cart {
    var addressType : AddressType
    var deliveryAddress : Address
    var item : [Meal]
    var deliveryOption : DeliveryOption
    var subTotal : Subtotal
}

enum AddressType : String {
    case home
    case work
    case others
}
struct Address {
    var name : String
    var fullAddress : String
    var pinCode : Int
    
}

enum DeliveryOption : String {
    case selfPickup
    case delivery
}

struct Subtotal {
    var itemTotal : Double
    var deliveryCharges : Double
    var gst : Double
    var discount : Double
    var grandTotal : Double {
        return itemTotal + deliveryCharges + gst - discount
    }
}
