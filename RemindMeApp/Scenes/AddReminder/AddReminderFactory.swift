//
//  AddReminderFactory.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import UIKit

enum AddReminderFactory {
    static func createViewController(controller: AddReminderControllerDelegate) -> UIViewController {
        let service = AddReminderServiceImpl()
        let viewModel = AddReminderViewModelImpl(service: service)
        let coordinator = AddReminderCoordinatorImpl()
        let addReminderViewController = AddReminderViewController(viewModel: viewModel, coordinator: coordinator)
        coordinator.controller = addReminderViewController
        addReminderViewController.delegate = controller
        viewModel.delegate = addReminderViewController
        return addReminderViewController
    }
}
