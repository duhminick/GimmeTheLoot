//
//  MonitorRow.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI

struct MonitorRow: View {
    @State var monitor: Monitor
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(monitor.name)
                    .font(.headline)
                HStack {
                    Text(monitor.type)
                        .font(.subheadline)
                    Text("-")
                        .font(.subheadline)
                    Text(monitor.keywordsDescription)
                        .font(.subheadline)
                }
            }
        }.padding(5)
    }
}

struct MonitorRow_Previews: PreviewProvider {
    static var previews: some View {
        MonitorRow(monitor: Monitor(id: "abc", name: "abc", type: "abc", keywords: ["abc", "cde"], url: "abc"))
    }
}
