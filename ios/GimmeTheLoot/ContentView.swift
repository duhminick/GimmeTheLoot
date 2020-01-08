//
//  ContentView.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/28/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI
import Apollo

struct ContentView: View {
    var body : some View {
        TabView {
            Listings(items: []).tabItem {
                Image(systemName: "cart.fill")
                Text("Listings")
            }
            
            Monitors(monitors: []).tabItem {
                Image(systemName: "magnifyingglass")
                Text("Monitors")
            }
        }.font(.headline)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
