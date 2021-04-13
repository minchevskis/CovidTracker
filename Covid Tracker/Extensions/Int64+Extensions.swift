//
//  Int64+Extensions.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 13.4.21.
//

import Foundation

extension Int64 {
    func getFormatedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(value: self))
        return string ?? ""
    }
}
