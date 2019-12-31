//
//  Monitors.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI

struct Monitors: View {
    @State var monitors: [Monitor]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(monitors) { monitor in
                    NavigationLink(destination: MonitorDetail(monitor: monitor)) {
                        MonitorRow(monitor: monitor)
                    }
                }
            }.navigationBarTitle("Monitors")
                .navigationBarItems(trailing: Button(action: {
                    print("yeet")
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.white)
                        .padding(7)
                        .background(Color.blue)
                        .mask(Circle())
                })
        }.onAppear {
            // Clear the array on appearance
            // This is to prevent duplicates in the list
            self.monitors.removeAll()
            
            ApolloNetwork.shared.apollo.fetch(query: GetMonitorsQuery()) { result in
                switch result {
                case .success(let graphQLResult):
                    if let result = graphQLResult.data?.monitors {
                        for monitor in result {
                            self.monitors.append(Monitor(id: monitor.id, name: monitor.name, type: monitor.type, keywords: monitor.keywords as! [String], url: monitor.url!))
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct Monitors_Previews: PreviewProvider {
    static var previews: some View {
        Monitors(monitors: [Monitor(id: "1", name: "Fanatec", type: "ebay", keywords: ["Fanatec", "CSW"], url: "https://ebay.com/")])
    }
}
