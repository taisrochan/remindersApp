//
//  HomeViewModelTests.swift
//  RemindMeAppTests
//
//  Created by Tais Rocha Nogueira on 10/02/24.
//

@testable import RemindMeApp
import XCTest

final class HomeViewModelTests: XCTestCase {
    let serviceSpy = HomeServiceSpy()
    let delegatSpy = HomeViewModelDelegateSpy()
    
    lazy var sut: HomeViewModelImpl = {
        let viewModel = HomeViewModelImpl(service: serviceSpy)
        viewModel.delegate = delegatSpy
        return viewModel
    }()
    
    func testGetReminders_givenShouldCallServiceToGetReminders() {
        //when
        sut.getReminders()
        
        //then
        XCTAssertEqual(serviceSpy.getRemindersCounter, 1)
    }
    
    func testGetReminders_givenApiSucced_thenShouldUpdateArrayAndTableView() {
        //given
        let data: RemindersModel = .init(title: "teste", date: Date.now)
        serviceSpy.getRemindersCompletionSetter = .success([data])
        
        //when
        sut.getReminders()
        
        //then
        XCTAssertEqual(serviceSpy.getRemindersCounter, 1)
        XCTAssertEqual(sut.remindersDataMatrix, [[data]])
        XCTAssertEqual(delegatSpy.updateTableViewCounter, 1)
    }
    
    func testGetReminders_givenApiFailed_thenShouldDelegateError() {
        //given
        serviceSpy.getRemindersCompletionSetter = .failure(ServiceErros.serviceFailure)
        
        //when
        sut.getReminders()
        
        //then
        XCTAssertEqual(serviceSpy.getRemindersCounter, 1)
        XCTAssertEqual(sut.remindersDataMatrix, [])
        XCTAssertEqual(delegatSpy.showErrorCounter, 1)
    }
    
    func testRemoveCell_whenIsNotCompleting_shouldDelegateUpdateAndRemoveElement() {
        //given
        let data: RemindersModel = .init(title: "teste", date: Date.now)
        sut.appendReminder(data)

        
        //when
        sut.removeCell(at: IndexPath(row: 0, section: 0), isCompleting: false)
        
        //then
        XCTAssertEqual(sut.remindersDataMatrix, [])
        XCTAssertEqual(delegatSpy.updateTableViewCounter, 2)
        XCTAssertEqual(serviceSpy.deleteReminderCounter, 1)
        XCTAssertEqual(serviceSpy.deleteReminderIdentifier, data.identifier)
    }
    
    func testAppendReminder_shouldAddreminderAndDelegateUpdate() {
        //given
        let data: RemindersModel = .init(title: "teste", date: Date.now)
        let dataNexMonth: RemindersModel = .init(title: "teste2", date: Date.now.addingOneMonth())

        //when
        sut.appendReminder(data)
        sut.appendReminder(dataNexMonth)
        
        //then
        XCTAssertEqual(sut.remindersDataMatrix, [[data], [dataNexMonth]])
        XCTAssertEqual(delegatSpy.updateTableViewCounter, 2)
    }
    
    func testGetMonthName_shouldReturnCorrectMonthName() {
        //given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let firstDateString = "01/01/2025"
        let firstDate = dateFormatter.date(from: firstDateString) ?? Date.now
        let data: RemindersModel = .init(title: "teste", date: firstDate)
        
        let dateString = "01/04/2025"
        let dateAprilMonth = dateFormatter.date(from: dateString) ?? Date.now
        let dataNexMonth: RemindersModel = .init(title: "teste2", date: dateAprilMonth)
        
        sut.appendReminder(data)
        sut.appendReminder(dataNexMonth)
        
        //when
        let firstMonthName = sut.getMonthName(section: 0)
        let secondMonthName = sut.getMonthName(section: 1)
        
        //then
        XCTAssertEqual(firstMonthName, "Janeiro")
        XCTAssertEqual(secondMonthName, "Abril")
    }

}
