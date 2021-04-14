//
//  DateDormater+Ext.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 14.4.21.
//

import Foundation
import UIKit

extension DateFormatter {
    
    static let isoFullFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formater.calendar = Calendar(identifier: .iso8601)
        formater.timeZone = TimeZone(secondsFromGMT: 0)
        formater.locale = Locale(identifier: "en_US_POSTIX")
        return formater
    }()  
}
