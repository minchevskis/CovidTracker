//
//  GlobalResponse.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 13.4.21.
//

import UIKit

struct GlobalResponse: Codable {
    let global: Global
    
    private enum CodingKeys: String, CodingKey {
        case global = "Global"
    }
}

struct Global: Codable {
    let confirmed: Int64
    let deaths: Int64
    let recovered: Int64
    
    private enum CodingKeys: String, CodingKey {
        case confirmed = "TotalConfirmed"
        case deaths = "TotalDeaths"
        case recovered = "TotalRecovered"
    }
}


