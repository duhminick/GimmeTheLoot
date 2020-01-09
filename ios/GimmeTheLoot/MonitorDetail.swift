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
    
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var type: Int = 0
    @State private var keywords: [String] = []
    
    @Environment(\.presentationMode) private var presentation
    
    var types: [String] = ["ebay", "reddit", "amazon"]
    
    var body: some View {
        Form {
            Section(header: Text("Monitor Detail")) {
                TextField("Monitor Name", text: $name)
            }
            
            Section(header: Text("Source Origin")) {
                TextField("URL", text: $url).disableAutocorrection(true).autocapitalization(.none).keyboardType(.webSearch)
            }
            
            Section(header: Text("Source Type")) {
                Picker(selection: $type, label: Text("Source")) {
                    ForEach(0..<types.count) { index in
                        Text(self.types[index]).tag([index])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Keywords")) {
                VStack(spacing: 15) {
                    ForEach(keywords.indices, id: \.self) { index in
                        HStack {
//                            Button(action: { }) {
//                                Image(systemName: "minus.circle.fill")
//                                    .foregroundColor(Color.red)
//                            }.onTapGesture {
//                                print("Removing \(self.keywords[index]) at index \(index)")
//                                self.keywords.remove(at: index)
//                            }
                            TextField("Keyword #\(index + 1)", text: self.$keywords[index])
                        }
                    }
                }
                Button(action: {
                    self.keywords.append("")
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color.green)
                        Text("Add New Keyword")
                    }
                }
            }
        }.navigationBarTitle(monitor != nil ? "Update Monitor" : "New Monitor")
        .navigationBarItems(trailing: Button(action: {
            if let _ = self.monitor {
                self.update()
            } else {
                self.create()
            }
            
            self.presentation.wrappedValue.dismiss()
        }) {
            if monitor != nil {
                Text("Update")
            } else {
                Text("Add")
            }
        }).onAppear {
            // Monitor was passed in, so we are updating rather than creating
            if let monitor = self.monitor {
                self.name = monitor.name
                self.url = monitor.url
                self.type = self.types.firstIndex(of: monitor.type) ?? 0
                self.keywords = monitor.keywords
            }
        }
    }
    
    func update() {
        ApolloNetwork.shared.apollo.perform(mutation: UpdateMonitorMutation(id: monitor!.id, name: name, type: self.types[self.type], keywords: self.arrayWithoutEmptyStrings(input: keywords), url: url)) { result in
            switch result {
            case .success(let graphQLResult):
                print(graphQLResult)
            case .failure(let error):
                print(error)
            }
        }
//        print(arrayWithoutEmptyStrings(input: self.keywords))
    }
    
    func create() {
        ApolloNetwork.shared.apollo.perform(mutation: CreateMonitorMutation(name: name, type: self.types[self.type], keywords: arrayWithoutEmptyStrings(input: keywords), url: url)) { result in
            switch result {
            case .success(let graphQLResult):
                print(graphQLResult)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteKeyword(at offsets: IndexSet) {
        for offset in offsets.reversed() {
            self.keywords.remove(at: offset)
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
    
    func arrayWithoutEmptyStrings(input: [String]) -> [String] {
        var result: [String] = []
        
        for string in input {
            if string != "" {
                result.append(string)
            }
        }
        
        return result
    }
}

struct MonitorDetail_Previews: PreviewProvider {
    static var previews: some View {
        MonitorDetail(monitor: Monitor(id: "1", name: "Testing", type: "ebay", keywords: ["Test", "ABC"], url: "https://test.com"))
    }
}
