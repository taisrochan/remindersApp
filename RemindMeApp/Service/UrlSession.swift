//
//  UrlSession.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import Foundation

protocol UrlSession {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: UrlSession {
}

typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

enum ServiceErros: Error {
    case invalidBody
    case serviceFailure
}

class MyUrlSession: UrlSession {
    static let shared = MyUrlSession()
    private let reminderUserDefaults = RemindersManager()
    
    
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let errorTask = URLSession.shared.dataTask(with: URL(string: "www.google.com")!) { (data, response, error) in
            completionHandler(nil, nil, ServiceErros.serviceFailure)
        }
        var data: Data?
        var urlResponse: URLResponse?
        var error: Error?
        guard let requestURL = request.url else {
            error = ServiceErros.invalidBody
            return errorTask
        }
        
        if request.url?.absoluteString == "www.remindersapi.com/getReminders" {
            let remindersArray = self.reminderUserDefaults.getAllReminders()
            let encoder = JSONEncoder()
            if let data_ = try? encoder.encode(remindersArray) {
                data = data_
                urlResponse = self.createSuccessUrlResponse(url: requestURL)
            } else {
                error = ServiceErros.invalidBody
            }
        } else {
            guard let body = request.httpBody,
                  let json = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
            else {
                error = ServiceErros.invalidBody
                return errorTask
            }
            let urlString = request.url?.absoluteString
            if urlString == "www.remindersapi.com/deleteReminder" {
                
                if let identifier = json["identifier"] as? String {
                    self.reminderUserDefaults.deleteReminder(identifier: identifier)
                    urlResponse = self.createSuccessUrlResponse(url: requestURL)
                } else {
                    print("Chave 'identifier' não encontrada.")
                    error = ServiceErros.invalidBody
                }
            } else if urlString == "www.remindersapi.com/completeReminder" {
                if let identifier = json["identifier"] as? String {
                    self.reminderUserDefaults.completeReminder(identifier: identifier)
                    urlResponse = self.createSuccessUrlResponse(url: requestURL)
                    
                } else {
                    print("Chave 'identifier' não encontrada.")
                    error = ServiceErros.invalidBody
                }
                
            } else if urlString == "www.remindersapi.com/addReminder" {
                if let title = json["title"] as? String,
                   let date = json["date"] as? TimeInterval {
                    self.reminderUserDefaults.addReminder(title: title, date: date)
                    urlResponse = self.createSuccessUrlResponse(url: requestURL)
                    
                } else {
                    print("Chave 'identifier' não encontrada.")
                    error = ServiceErros.invalidBody
                }
            }
        }
        let task = URLSession.shared.dataTask(with: requestURL) { (_, _, _) in
            let deadline = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                completionHandler(data, urlResponse, error)
            }
        }
        return task
    }
    
    private func createSuccessUrlResponse(url: URL) -> HTTPURLResponse? {
        let statusCode = 200
        let httpVersion = "HTTP/1.1"
        let headerFields = ["Content-Type": "text/html"]
        
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)
        return urlResponse
    }
}
