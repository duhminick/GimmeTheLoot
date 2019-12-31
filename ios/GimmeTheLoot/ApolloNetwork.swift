//
//  ApolloNetwork.swift
//  GimmeTheLoot
//
//  Created by Dominic Sciascia on 12/29/19.
//  Copyright © 2019 Dominic Sciascia. All rights reserved.
//

import Foundation
import Apollo
import ApolloWebSocket

class ApolloNetwork {
    static let shared = ApolloNetwork()
    
    /// A web socket transport to use for subscriptions
    private lazy var webSocketTransport: WebSocketTransport = {
      let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "graphQLWebSocket") as! String)!
      let request = URLRequest(url: url)
      return WebSocketTransport(request: request)
    }()
    
    /// An HTTP transport to use for queries and mutations
    private lazy var httpTransport: HTTPNetworkTransport = {
        let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "graphQLHTTP") as! String)!
      return HTTPNetworkTransport(url: url, delegate: self)
    }()

    /// A split network transport to allow the use of both of the above
    /// transports through a single `NetworkTransport` instance.
    private lazy var splitNetworkTransport = SplitNetworkTransport(
      httpNetworkTransport: self.httpTransport,
      webSocketNetworkTransport: self.webSocketTransport
    )
    
    private(set) lazy var apollo = ApolloClient(networkTransport: splitNetworkTransport)
}

extension ApolloNetwork: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        
        let token = Bundle.main.object(forInfoDictionaryKey: "graphQLToken") as! String
        headers["Authorization"] = "Bearer \(token)"
        
        request.allHTTPHeaderFields = headers
    }
}
