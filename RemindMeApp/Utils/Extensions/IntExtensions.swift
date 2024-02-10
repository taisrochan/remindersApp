//
//  IntExtensions.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import Foundation

extension Int {
    func monthAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        if let date = dateFormatter.date(from: String(format: "%02d", self)) {
            let nameMonthFormatter = DateFormatter()
            nameMonthFormatter.dateFormat = "MMMM"
            return nameMonthFormatter.string(from: date)
        }
        
        return ""
    }
}
