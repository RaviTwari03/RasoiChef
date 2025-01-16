//
//  Order.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation


struct HomeCook{
    var name:String
    
}

struct Meal
{
    var name:String
}

struct Order{
    var orderID:UUID
    var orderNumber:String
    var homecook:HomeCook
    var items:[Meal]
    var date:Date
}



