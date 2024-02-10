//
//  HomeServiceSpy.swift
//  RemindMeAppTests
//
//  Created by Tais Rocha Nogueira on 10/02/24.
//

@testable import RemindMeApp

class HomeServiceSpy: HomeService {
    var deleteReminderCounter = 0
    var deleteReminderIdentifier: String?
    var completeReminderCounter = 0
    var completeReminderIdentifier: String?
    var getRemindersCounter = 0
    var getRemindersCompletionSetter: (Result<[RemindMeApp.RemindersModel], Error>) = .success([])
    
    
    func deleteReminder(identifier: String) {
        deleteReminderCounter += 1
        deleteReminderIdentifier = identifier
    }
    
    func completeReminder(identifier: String) {
        completeReminderCounter += 1
        completeReminderIdentifier = identifier
    }
    
    func getReminders(completion: @escaping (Result<[RemindMeApp.RemindersModel], Error>) -> Void) {
        getRemindersCounter += 1
        completion(getRemindersCompletionSetter)
    }
    
    
}
