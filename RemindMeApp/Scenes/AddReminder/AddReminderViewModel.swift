//
//  AddReminderViewModel.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import UIKit

protocol AddReminderViewModelDelegate: AnyObject {
    func didSuccedReminderCreation()
    func didFailReminderCreation()
}

protocol AddReminderViewModel {
    func isDateValid(textFieldText: String?) -> Bool
    func addReminder(title: String, date: TimeInterval)
}

class AddReminderViewModelImpl: AddReminderViewModel {
    private let service: AddReminderService
    weak var delegate: AddReminderViewModelDelegate?
    
    init(service: AddReminderService) {
        self.service = service
    }
    
    func isDateValid(textFieldText: String?) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateString = textFieldText,
           let date = dateFormatter.date(from: dateString),
            dateString == dateFormatter.string(from: date) {
            return true
        } else {
            return false
        }
    }
    
    func addReminder(title: String, date: TimeInterval) {
        service.addReminder(title: title, date: date) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.didSuccedReminderCreation()
            case .failure:
                self.delegate?.didFailReminderCreation()
            }
        }
    }
}
