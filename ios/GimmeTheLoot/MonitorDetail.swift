//
//  MonitorDetail.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/30/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI

struct MonitorDetail: View {
    @State var monitor: Monitor?
    
    /// New Monitor and Update Monitor
    /// Add and Update
    @State private var barTitle: String = "New Monitor"
    @State private var barItemText: String = "Add"
    
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var type: Int = 0
    @State private var keywords: String = ""
    
    var types: [String] = ["ebay", "reddit"]
    
    var body: some View {
        Form {
            Section(header: Text("Monitor Detail")) {
                TextField("Monitor Name", text: $name)
            }
            
            Section(header: Text("Source Origin")) {
                TextField("URL", text: $url)
            }
            
            Section(header: Text("Source Type")) {
                Picker(selection: $type, label: Text("Source")) {
                    ForEach(0..<types.count) { index in
                        Text(self.types[index]).tag([index])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Keywords")) {
                TextField("Keywords", text: $keywords)
            }
        }.navigationBarTitle(self.barTitle)
        .navigationBarItems(trailing: Button(action: {
            if let _ = self.monitor {
                self.update()
            } else {
                self.create()
            }
        }) {
            Text(self.barItemText)
        }).onAppear {
            // Monitor was passed in, so we are updating rather than creating
            if let monitor = self.monitor {
                self.barTitle = "Update Monitor"
                self.barItemText = "Update"
                self.name = monitor.name
                self.url = monitor.url
                self.type = self.types.firstIndex(of: monitor.type) ?? 0
                self.keywords = self.stringFromKeywordArray(input: monitor.keywords)
            }
        }
    }
    
    func update() {
        ApolloNetwork.shared.apollo.perform(mutation: CreateMonitorMutation(name: name, type: self.types[self.type], keywords: self.keywordArrayFromString(input: keywords), url: url)) { result in
            switch result {
            case .success(let graphQLResult):
                print(graphQLResult)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func create() {
        ApolloNetwork.shared.apollo.perform(mutation: CreateMonitorMutation(name: name, type: self.types[self.type], keywords: self.keywordArrayFromString(input: keywords), url: url)) { result in
            switch result {
            case .success(let graphQLResult):
                print(graphQLResult)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func keywordArrayFromString(input: String) -> [String] {
        return input.components(separatedBy: ", ")
    }
    
    func stringFromKeywordArray(input: [String]) -> String {
        var buffer: String = ""
        
        for i in 0..<input.count - 1 {
            buffer += "\(input[i]), "
        }
        
        buffer += input[input.count - 1]
        
        return buffer
    }
}

struct MonitorDetail_Previews: PreviewProvider {
    static var previews: some View {
        MonitorDetail(monitor: nil)
    }
}
