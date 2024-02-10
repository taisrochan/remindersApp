//
//  HomeViewModelDelegate.swift
//  RemindMeAppTests
//
//  Created by Tais Rocha Nogueira on 10/02/24.
//

@testable import RemindMeApp

class HomeViewModelDelegateSpy: HomeViewModelDelegate {
    var updateTableViewCounter = 0
    var showErrorCounter = 0
    
    func updateTableView() {
        updateTableViewCounter += 1
    }
    
    func showError() {
        showErrorCounter += 1
    }
}
