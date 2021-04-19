//
//  GlobalAPI.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 19.4.21.
//

import Foundation

enum GlobalAPI: Endpoint {
    case getSummary
    
    
    var request: URLRequest? {
        switch self {
        case .getSummary:
            return request(forEndpoint: "/summary")
        }
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    var httpHeaders: [String : String]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    
}
