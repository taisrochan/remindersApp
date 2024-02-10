//
//  RemindersUserDefaults.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import Foundation

class RemindersManager {
    
    private let userDefaultsKey = "YourAppName_Reminders"
    private var reminders: [RemindersModel]
    
    init() {
        if let savedRemindersData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let savedReminders = try? decoder.decode([RemindersModel].self, from: savedRemindersData) {
                self.reminders = savedReminders
            } else {
                self.reminders = []
            }
        } else {
            self.reminders = []
        }
    }
    
    func addReminder(title: String, date: TimeInterval) {
        let correctDate = Date(timeIntervalSince1970: date)
        let newReminder = RemindersModel(title: title, date: correctDate)
        reminders.append(newReminder)
        saveReminders()
    }
    
    func deleteReminder(identifier: String) {
        reminders = reminders.filter { $0.identifier != identifier }
        saveReminders()
    }
    
    func completeReminder(identifier: String) {
        if let index = reminders.firstIndex(where: { $0.identifier == identifier }) {
            reminders[index].isCompleted = true
            saveReminders()
        }
    }
    
    func getAllReminders() -> [RemindersModel] {
        return reminders
    }
    
    private func saveReminders() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(reminders) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
}
