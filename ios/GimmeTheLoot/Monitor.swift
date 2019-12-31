//
//  Monitor.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import Foundation

struct Monitor: Hashable, Identifiable {
    var id: String
    var name: String
    var type: String
    var keywords: [String]
    var url: String
    
    var keywordsDescription: String {
        var buffer: String = ""
        
        for i in 0..<keywords.count - 1 {
            buffer += "\(keywords[i]), "
        }
        
        buffer += keywords[keywords.count - 1]
        
        return buffer
    }
}
