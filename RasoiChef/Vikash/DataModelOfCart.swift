//
//  DataModelOfCart.swift
//  RasoiChef
//
//  Created by Batch - 1 on 16/01/25.
//

import Foundation

struct Cart {
    var addressType: AddressType
    var deliveryAddress: Address
    var items: CartItem
    var deliveryOption: DeliveryOption
    var subtotal: Subtotal
}

enum AddressType: String {
    case home
    case work
    case others
}


struct Address {
    var name: String
    var fullAddress: String
    var pincode: String
}



struct CartItem {
    var id: UUID
    var name: String
    var description: String
    var pricePerUnit: Double
    var quantity: Int
    var totalPrice: Double {
        return pricePerUnit * Double(quantity)
    }
}

enum DeliveryOption: String {
    case selfPickup
    case delivery
}


struct Subtotal {
    var itemTotal: Double
    var deliveryCharges: Double
    var gst: Double
    var discount: Double
    var grandTotal: Double {
        return itemTotal + deliveryCharges + gst - discount
    }
}

