//
//  HomeService.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import Foundation

protocol HomeService {
    func deleteReminder(identifier: String)
    func completeReminder(identifier: String)
    func getReminders(completion: @escaping (Result<[RemindersModel], Error>) -> Void)
}

class HomeServiceImpl: HomeService {
    private let userSession: UrlSession
    
    init(userSession: UrlSession = MyUrlSession.shared) {
        self.userSession = userSession
    }
    
    func deleteReminder(identifier: String) {
        let body = ["identifier": identifier]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []),
              let url = URL(string: Endpoints.deleteReminder) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpBody = jsonData
        let task = userSession.dataTask(with: request) { _, _, error in
            if error != nil {
                print("erro ao deletar o request")
            }
        }
        task.resume()
    }
    
    func completeReminder(identifier: String) {
        let body = ["identifier": identifier]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []),
              let url = URL(string: Endpoints.completeReminder) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpBody = jsonData
        let task = userSession.dataTask(with: request) { _, _, error in
            if error != nil {
                print("erro ao completar o request")
            }
        }
        task.resume()
    }
    
    func getReminders(completion: @escaping (Result<[RemindersModel], Error>) -> Void) {
        guard let url = URL(string: Endpoints.getReminders) else {
            return
        }
        let request = URLRequest(url: url)
        let task = userSession.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data,
               let remindersArray = try? decoder.decode([RemindersModel].self, from: data) {
                completion(.success(remindersArray))
            } else if (response as? HTTPURLResponse)?.statusCode == 200 {
                completion(.success([]))
            } else {
                completion(.failure(ServiceErros.serviceFailure))
            }
        }
        task.resume()
    }
}
