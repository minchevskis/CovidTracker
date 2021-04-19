//
//  CountryAPI.swift
//  CoronaTraker
//
//  Created by Darko Spasovski on 19.4.21.
//

import Foundation

enum CountryAPI: Endpoint {
    //https://api.covid19api.com/country/[country-Slug]/status/confirmed/live?from=[fromDate]&to=[toDate]
    case getConfirmedCases(_ country: Country,_ from: Date,_ to: Date)

    //https://api.covid19api.com/dayone/country/south-africa/status/confirmed
    case getConfirmedCasesDayOne(country: Country)

    //https://api.covid19api.com/dayone/country/south-africa
    case getAllStatusForDayOne(country: Country)

    var request: URLRequest? {
        switch self {
        case .getConfirmedCases(let country, _, _):
            return request(forEndpoint: "/country/\(country.slug)/status/confirmed/live")
        case .getConfirmedCasesDayOne(let country):
            return request(forEndpoint: "/dayone/country/\(country.slug)/status/confirmed")
        case .getAllStatusForDayOne(let country):
            return request(forEndpoint: "/dayone/country/\(country.slug)")
        }
    }

    var httpMethod: String {
        switch self {
        case .getConfirmedCases,
             .getConfirmedCasesDayOne,
             .getAllStatusForDayOne:

            return "GET"
        }
    }

    var httpHeaders: [String : String]? {
        return nil
    }

    var body: [String : Any]? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getConfirmedCases(_ , let fromDate, let toDate):
            var queryItems = [URLQueryItem]()
            let fromItem = URLQueryItem(name: "from", value: DateFormatter.isoFullFormater.string(from: fromDate))
            let toItem = URLQueryItem(name: "to", value: DateFormatter.isoFullFormater.string(from: toDate))
            queryItems.append(fromItem)
            queryItems.append(toItem)
            return queryItems
        default:
            return nil
        }
    }
}
