//
//  HomeViewModel.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func updateTableView()
    func showError()
}

protocol HomeViewModel: AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    var remindersDataMatrix: [[RemindersModel]] { get }
    func getReminders()
    func removeCell(at indexPath: IndexPath, isCompleting: Bool)
    func appendReminder(_ reminder: RemindersModel)
    func getMonthName(section: Int) -> String
}

class HomeViewModelImpl: HomeViewModel {
    private var remindersArray: [RemindersModel] = []
    
    weak var delegate: HomeViewModelDelegate?
    
    var remindersDataMatrix: [[RemindersModel]] {
        return groupDatesByMonth(array: remindersArray)
    }
    
    private let service: HomeService
    
    init(service: HomeService) {
        self.service = service
    }
    
    func getReminders() {
        service.getReminders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                remindersArray = data
            case .failure:
                delegate?.showError()
            }
            delegate?.updateTableView()
        }
    }
    
    func removeCell(at indexPath: IndexPath, isCompleting: Bool) {
        let j = indexPath.section
        let i = indexPath.row
        let reminder = remindersDataMatrix[j][i]
        reminder.isCompleted = isCompleting
        let identifier = reminder.identifier
        
        if isCompleting {
            service.completeReminder(identifier: identifier)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.removeCellAndUpdate(identifier: identifier)
            }
        } else {
            service.deleteReminder(identifier: identifier)
            removeCellAndUpdate(identifier: identifier)
        }
    }
    
    func appendReminder(_ reminder: RemindersModel) {
        remindersArray.append(reminder)
        delegate?.updateTableView()
    }
    
    func getMonthName(section: Int) -> String {
        let firstMonthElement = remindersDataMatrix[section][0]
        let month = firstMonthElement.date.monthAsInteger().monthAsString()
        return month.capitalized
    }
}

private extension HomeViewModelImpl {
    func groupDatesByMonth(array: [RemindersModel]) -> [[RemindersModel]] {
        let ordenatedArray = array.sorted(by: { $0.date < $1.date})
        var arrayOfModel: [[RemindersModel]] = []
        var monthDict: [Int: [RemindersModel]] = [:]
        for model in ordenatedArray {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: model.date)

            if let month = components.month {
                if monthDict[month] == nil {
                    monthDict[month] = []
                }
                monthDict[month]?.append(model)
            }
        }
        arrayOfModel = monthDict.values.map { $0 }
        let sortedMatrix = arrayOfModel.sorted(by: {
            $0[0].date < $1[0].date
        })
        return sortedMatrix
    }
    
    func removeCellAndUpdate(identifier: String) {
        remindersArray.removeAll(where: {
            $0.identifier == identifier
        })
        delegate?.updateTableView()
    }
}
