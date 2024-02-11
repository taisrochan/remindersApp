//
//  UrlSessionSpy.swift
//  RemindMeAppTests
//
//  Created by Tais Rocha Nogueira on 11/02/24.
//

@testable import RemindMeApp
import Foundation

class UrlSessionSpy: UrlSession {
    var dataSetter: Data?
    var responseSetter: URLResponse?
    var errorSetter: Error?
    var dataTaskCounter = 0
    var requestSpy: URLRequest?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCounter += 1
        requestSpy = request
        
        let task = URLSession.shared.dataTask(with: URL(string: "www.any.com")!) { (data, response, error) in
            completionHandler(self.dataSetter, self.responseSetter, self.errorSetter)
        }
        return task
    }
    
}
