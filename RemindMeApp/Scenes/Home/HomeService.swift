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
    private let urlSession: UrlSession
    
    init(urlSession: UrlSession = MyUrlSession.shared) {
        self.urlSession = urlSession
    }
    
    func deleteReminder(identifier: String) {
        let body = ["identifier": identifier]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []),
              let url = URL(string: Endpoints.deleteReminder) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        let task = urlSession.dataTask(with: request) { _, _, error in
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
        request.httpMethod = "POST"
        let task = urlSession.dataTask(with: request) { _, _, error in
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
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = urlSession.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data,
               let remindersArray = try? decoder.decode([RemindersModel].self, from: data) {
                let filterArray = remindersArray.filter({ $0.isCompleted == false })
                completion(.success(filterArray))
            } else if (response as? HTTPURLResponse)?.statusCode == 200 {
                completion(.success([]))
            } else {
                completion(.failure(ServiceErros.serviceFailure))
            }
        }
        task.resume()
    }
}
