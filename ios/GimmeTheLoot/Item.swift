//
//  Item.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    var id: String
    var name: String
    var url: String
    var price: Double?
    var source: String
    var date: String
    var archived: Bool
    
    var priceDescription: String {
        guard let price = price else {
            return ""
        }
        
        return String(format: "$%.02f", price)
    }
}
