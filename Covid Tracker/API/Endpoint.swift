//
//  Endpoint.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 19.4.21.
//

import UIKit

protocol Endpoint {
    //http or https
    var scheme: String { get }
    
    // BASE URL (api.covid19api.com)
    var host: String { get }
    
    // instead of URL we have REquest beacause we will use URLSession
    var request: URLRequest? { get }
    
    //http method(get, post, delete, put)
    var httpMethod: String { get }
    
    // Content-Type:application/json ...
    var httpHeaders:[String:String]? { get }
    
    // Body of the request (parameters) json
    var body:[String:Any]? { get }
    
    // URL parameters (&itemOne = valueONe ...)
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.covid19api.com"
    }
}

// scheme://host/path?queryItems
// https: //api.covid19api.com/countries?from=/...
extension Endpoint {
    func request(forEndpoint path: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let httpHeaders = httpHeaders {
            httpHeaders.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        
        return nil
    }
}
