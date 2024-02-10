//
//  RemindersModel.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import UIKit

class RemindersModel: Codable, Equatable {
    var title: String
    var date: Date
    var isCompleted: Bool
    var identifier: String = UUID.init().uuidString
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
        self.isCompleted = false
    }
    
    static func == (lhs: RemindersModel, rhs: RemindersModel) -> Bool {
        return lhs.title == rhs.title && lhs.date == rhs.date && lhs.isCompleted == rhs.isCompleted && lhs.identifier == rhs.identifier
    }
}
