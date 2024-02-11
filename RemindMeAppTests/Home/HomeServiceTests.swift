//
//  HomeServiceTests.swift
//  RemindMeAppTests
//
//  Created by Tais Rocha Nogueira on 11/02/24.
//

@testable import RemindMeApp
import XCTest

final class HomeServiceTests: XCTestCase {
    let urlSession = UrlSessionSpy()
    
    lazy var sut: HomeServiceImpl = {
        let service = HomeServiceImpl(urlSession: urlSession)
        return service
    }()
    
    func testDeleteReminder_shouldPerformDeleteRequest() throws {
        //given
        let id = "teste1233"
        //when
        sut.deleteReminder(identifier: id)
        
        //then
        let data = try XCTUnwrap(urlSession.requestSpy?.httpBody)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let jsonDictionary = jsonObject as? [String: Any]
        let jsonIdentifier = try XCTUnwrap(jsonDictionary?["identifier"] as? String)
        XCTAssertEqual(urlSession.dataTaskCounter, 1)
        XCTAssertEqual(jsonIdentifier, id)
    }
}
