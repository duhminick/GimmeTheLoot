//
//  ItemRow.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI

struct ItemRow: View {
    var item: Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                HStack {
                    Text(item.source)
                        .font(.subheadline)
                    Text("-")
                        .font(.subheadline)
                    Text(item.formattedDate)
                        .font(.subheadline)
                }
            }
            
            Spacer()
            
            // TODO: find an alternative to this hack
            if (item.priceDescription != "$0.00") {
                Text(item.priceDescription)
                .padding(5)
                .foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.blue)
                        .overlay(
                            Text(item.priceDescription)
                                .font(.subheadline)
                                .foregroundColor(Color.white)
                        )
                )
            }
                
        }.padding(5)
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item: Item(id: "1", name: "Fanatec", url: "https://ebay.com/", price: 20.00, source: "ebay", date: "lol", archived: false))
    }
}
