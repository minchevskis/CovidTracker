//
//  WebService.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 19.4.21.
//

import UIKit

typealias ResultsCompletion<T> = (Result<T,Error>) -> Void

protocol WebServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultsCompletion<T>)
}

class WebService: WebServiceProtocol {
 
    let urlSession: URLSession
    private let parser: Parser

    // let parser
    init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default), parser: Parser = Parser() ) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultsCompletion<T>) {
        guard let request = endpoint.request else {
            print("Request is nil")
            return
        }
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                // Not authorized to do this request
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Missing data")
                return
            }
            
            self.parser.json(data: data, completion: completion)
        }
        
        task.resume()
    }
}


struct Parser {
    
    private let jsonDecoder = JSONDecoder()
    
    func json<T: Decodable>(data: Data, completion: @escaping ResultsCompletion<T>) {
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
