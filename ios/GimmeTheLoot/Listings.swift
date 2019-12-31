//
//  Listings.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI

struct Listings: View {
    @State var items: [Item]
    @State var initialFetchComplete: Bool = false
    
    // For WebView modal
    @State private var showModal: Bool = false
    @State private var selectedItemURL: URL? = nil
    
    // For ActionSheet
    @State private var showActionSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        // Show WebView
                        self.showModal = true
                        self.selectedItemURL = URL(string: item.url)
                    }) {
                        ItemRow(item: item)
                    }
                }.onDelete(perform: deleteItems)
            }.navigationBarTitle("Listings")
            .navigationBarItems(trailing: Button(action: {
                self.showActionSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .padding(7)
                    .foregroundColor(Color.primary)
                    .background(Color.secondary)
                    .mask(Circle())
            }).actionSheet(isPresented: $showActionSheet, content: {
                ActionSheet(title: Text("Options"), message: Text("Select an action to perform"), buttons: [
                    .destructive(Text("Archive All"), action: {
                        ApolloNetwork.shared.apollo.perform(mutation: ArchiveAllItemsMutation()) { result in
                            switch result {
                            case .success(_):
                                self.items.removeAll()
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }),
                    .cancel()
                ])
            })
        }.onAppear(perform: {
            // Initial fetch of items from API
            if !self.initialFetchComplete {
                ApolloNetwork.shared.apollo.fetch(query: GetItemsQuery(archived: false)) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let items = graphQLResult.data?.items {
                            for item in items {
                                // Append results to the items state array
                                self.items.append(Item(id: item.id, name: item.name, url: item.url, price: item.price, source: item.source ?? "NA", date: item.date, archived: item.archived))
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
                self.initialFetchComplete = true
            }
            
            // Subscribe to API for new items
            ApolloNetwork.shared.apollo.subscribe(subscription: ItemAddedSubscription()) { result in
                switch result {
                case .success(let graphQLResult):
                    if let item = graphQLResult.data?.itemAdded {
                        self.items.insert(Item(id: item.id, name: item.name, url: item.url, price: item.price, source: item.source ?? "NA", date: item.date, archived: item.archived), at: 0)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }).sheet(isPresented: $showModal) {
            WebView(request: URLRequest(url: self.selectedItemURL!))
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            print("Archiving \(self.items[offset].name)")
            
            // Archive item through API
            ApolloNetwork.shared.apollo.perform(mutation: ArchiveItemMutation(id: self.items[offset].id)) { result in
                print(result)
            }
            
            // Remove from state
            self.items.remove(at: offset)
        }
    }
}

struct Listings_Previews: PreviewProvider {
    static var previews: some View {
        Listings(items: [
            Item(id: "abc", name: "Fanatec", url: "https://ebay.com/", price: 20.00, source: "ebay", date: "", archived: false),
            Item(id: "abcd", name: "Fanatec 2", url: "https://ebay.com/", price: 20.00, source: "ebay", date: "lol", archived: false),
            Item(id: "abcde", name: "Fanatec 3", url: "https://ebay.com/", price: 20.00, source: "ebay", date: "Date.init()", archived: false),
        ])
    }
}
