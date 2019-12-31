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
    
    var body: some View {
        Form {
            Section {
                Text("Monitor Name")
            }
        }.navigationBarTitle("New Monitor")
    }
}

struct MonitorDetail_Previews: PreviewProvider {
    static var previews: some View {
        MonitorDetail(monitor: nil)
    }
}
