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
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let opDate = dateFormatter.date(from: self.date)
        
        guard let date = opDate else {
            return self.date
        }
        
        let dateFormatterToString = DateFormatter()
        dateFormatterToString.dateFormat = "MM/dd/yyyy @ hh:mm a"
        return dateFormatterToString.string(from: date)
    }
}
