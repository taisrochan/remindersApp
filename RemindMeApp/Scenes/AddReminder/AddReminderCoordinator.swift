//
//  AddReminderCoordinator.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 08/02/24.
//

import UIKit

protocol AddReminderCoordinator {
    func showDiscardChangesAlert()
    func navigateBack()
}

class AddReminderCoordinatorImpl: AddReminderCoordinator {
    
    weak var controller: AddReminderViewController?
    
    func showDiscardChangesAlert() {
        let alert = UIAlertController(title: "Descartar Alterações", message: "Deseja descartar as alterações?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Descartar", style: .destructive) { _ in
            self.navigateBack()
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func navigateBack() {
        controller?.navigationController?.popViewController(animated: true)
        
    }
}
