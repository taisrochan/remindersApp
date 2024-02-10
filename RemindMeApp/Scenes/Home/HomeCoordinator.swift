//
//  HomeCoordinator.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import UIKit

protocol HomeCoordinator {
    func presentAddReminderScreen()
    func showDeleteCellAlert(didConfirmDelete: @escaping () -> Void)
}

class HomeCoordinatorImpl: HomeCoordinator {
    weak var controller: HomeViewController?
    
    func presentAddReminderScreen() {
        guard let controller = controller else {
            return
        }
        let addReminderViewController = AddReminderFactory.createViewController(controller: controller)
        controller.navigationController?.pushViewController(addReminderViewController, animated: true)
    }
    
    func showDeleteCellAlert(didConfirmDelete: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Confirmação",
                                                message: "Tem certeza de que deseja excluir este item?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) { (action) in
            didConfirmDelete()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        controller?.present(alertController, animated: true, completion: nil)
    }
}
