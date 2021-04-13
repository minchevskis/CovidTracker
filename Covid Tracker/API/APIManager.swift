//
//  APIManager.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import Foundation
import Alamofire

typealias CountriesResultCompletion = ((Result<[Country], Error>) -> Void)
typealias GlobalInfoCompletion = ((Result<Global, Error>) -> Void)

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func getAllCountries(completion: @escaping (CountriesResultCompletion)) {
        AF.request("https://api.covid19api.com/countries").responseDecodable(of: [Country].self) { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let countries):
                completion(.success(countries))
            }
        }
    }
    
    func getGlobalInfo(completion: @escaping (GlobalInfoCompletion)) {
        AF.request("https://api.covid19api.com/summary", method: .get).responseDecodable(of: GlobalResponse.self) { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let globalResponse):
                completion(.success(globalResponse.global))
            }
        }
    }
}
