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
typealias ComfirmedCasesByDayCompletion = ((Result<[ConfirmedCasesByDay], Error>) -> Void)

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
    
    func getConfirmedCases(for country: String, from: Date? = nil, to: Date? = nil, completion: @escaping ComfirmedCasesByDayCompletion) {
        
        let fetchTodaysDate = (from == nil && to == nil) ? Date().minus(days: 1) : nil
        
        var urlString = "https://api.covid19api.com/country/" + country + "/status/confirmed/live?"
        
        if let today = fetchTodaysDate{
            urlString = urlString + "from=" + DateFormatter.isoFullFormater.string(from: today)
        } else {
            urlString = urlString + "from=" + DateFormatter.isoFullFormater.string(from: from!) + "&to=" + DateFormatter.isoFullFormater.string(from: to!)
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.isoFullFormater)
        
        AF.request(urlString).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let days = try jsonDecoder.decode([ConfirmedCasesByDay].self, from: data)
                    completion(.success(days))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
