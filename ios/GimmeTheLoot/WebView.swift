//
//  WebView.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let request: URLRequest
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WebView.UIViewType, context: UIViewRepresentableContext<WebView>) {
        uiView.load(request)
    }
}
