//
//  Country.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import Foundation

struct Country: Codable {
    let name: String
    let slug: String
    let isoCode: String
    
    private enum CodingKeys: String, CodingKey {
        case name    = "Country"
        case slug    = "Slug"
        case isoCode = "ISO2"
    }
}
