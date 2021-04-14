//
//  ConfirmedCaseDay.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 14.4.21.
//

import Foundation
import UIKit

struct ConfirmedCasesByDay: Codable {
    let countryName: String
    let countryCode: String
    let lat: String
    let lon: String
    let cases: Int
    let date: Date
    
    private enum CodingKeys: String, CodingKey {
        case countryName = "Country"
        case countryCode = "CountryCode"
        case lat = "Lat"
        case lon = "Lon"
        case cases = "Cases"
        case date = "Date"
    }
}


