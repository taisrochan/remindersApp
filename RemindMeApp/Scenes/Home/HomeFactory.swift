//
//  HomeFactory.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import UIKit

enum HomeFactory {
    static func createViewController() -> UIViewController {
        let service = HomeServiceImpl()
        let viewModel = HomeViewModelImpl(service: service)
        let coordinator = HomeCoordinatorImpl()
        let viewController = HomeViewController(viewModel: viewModel, coordinator: coordinator)
        viewModel.delegate = viewController
        coordinator.controller = viewController
        return viewController
    }
}
