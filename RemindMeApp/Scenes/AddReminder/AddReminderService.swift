//
//  AddReminderService.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import Foundation

protocol AddReminderService {
    func addReminder(title: String, date: TimeInterval, completion: @escaping (Result<String, Error>) -> Void)
}

class AddReminderServiceImpl: AddReminderService {
    private let userSession: UrlSession
    
    init(userSession: UrlSession = MyUrlSession.shared) {
        self.userSession = userSession
    }
    
    func addReminder(title: String, date: TimeInterval, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String : Any] = ["title": title, "date": date]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []),
              let url = URL(string: Endpoints.addReminder) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpBody = jsonData
        let task = userSession.dataTask(with: request) { _, _, error in
            if error != nil {
                completion(.failure(ServiceErros.serviceFailure))
            } else {
                completion(.success("suceso"))
            }
        }
        task.resume()
    }
}
