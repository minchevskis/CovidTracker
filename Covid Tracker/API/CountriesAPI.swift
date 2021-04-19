//
//  CountriesAPI.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 19.4.21.
//

import UIKit

enum CountriesAPI: Endpoint {
    case getAllCountries
    
    var request: URLRequest? {
        switch self {
        case .getAllCountries:
            return request(forEndpoint: "/countries")
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

