//
//  RemindersDataManagerViewController.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 07/02/24.
//

import UIKit

protocol AddReminderControllerDelegate: AnyObject {
    func passRemindersInfo(title: String, date: Date)
}

class AddReminderViewController: UIViewController {
    
    @IBOutlet weak var titleReminderTextField: UITextField!
    @IBOutlet weak var dateReminderTextField: UITextField!
    @IBOutlet weak var saveReminderButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var cancelSavingReminderButton: UIButton!
    
    private let datePicker = UIDatePicker()
    var hasChanges = false
    weak var delegate: AddReminderControllerDelegate?
    let viewModel: AddReminderViewModel
    let coordinator: AddReminderCoordinator
    
    init(viewModel: AddReminderViewModel, coordinator: AddReminderCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadingView.isHidden = true
        titleReminderTextField.returnKeyType = .next
        setupDoneButtonToolbar()
        setupDatePicker()
        textFieldDidChange()
        navigationItem.title = "Adicionar Lembrete"
        
        [titleReminderTextField, dateReminderTextField].forEach { textField in
            textField?.addTarget(self,
                                action: #selector(textFieldDidChange),
                                for: .editingChanged)
            textField?.delegate = self
        }
        titleReminderTextField?.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange() {
        let titleText = titleReminderTextField.text ?? ""
        let dateText = dateReminderTextField.text ?? ""
        let thereIsTextInBothTextFields = !titleText.isEmpty && !dateText.isEmpty
        let isDateValid = viewModel.isDateValid(textFieldText: dateReminderTextField.text)
        let shouldEnableSaveButton = thereIsTextInBothTextFields && isDateValid
        saveReminderButton.isEnabled = shouldEnableSaveButton
        saveReminderButton.alpha = saveReminderButton.isEnabled ? 1.0 : 0.5
        let hasDataInTextFields = !titleText.isEmpty || !dateText.isEmpty
        hasChanges = hasDataInTextFields
    }
    
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateReminderTextField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
    }
    
    func setupDoneButtonToolbar() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Pronto", style: .done, target: self, action: #selector(doneButtonPressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = .systemBlue
        
        doneToolbar.items = [flexSpace, doneButton]
        
        dateReminderTextField?.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonPressed() {
        self.view.endEditing(true)
    }
    
    @objc func datePickerValueChanged() {
        dateReminderTextField.text = datePicker.date.toString()
        textFieldDidChange()
    }

    @IBAction func saveReminderButton(_ sender: UIButton) {
        loadingView.isHidden = false
        loading.startAnimating()
        
        dateReminderTextField.resignFirstResponder()
        let title = titleReminderTextField.text ?? ""
        let selectedDate = datePicker.date
        viewModel.addReminder(title: title, date: selectedDate.timeIntervalSince1970)
    }
    
    @IBAction func cancelSavindReminderButton(_ sender: UIButton) {
        if hasChanges {
            coordinator.showDiscardChangesAlert()
        } else {
            coordinator.navigateBack()
        }
    }
}

extension AddReminderViewController: AddReminderViewModelDelegate {
    func didSuccedReminderCreation() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            let title = self.titleReminderTextField.text ?? ""
            let selectedDate = self.datePicker.date
            self.delegate?.passRemindersInfo(title: title, date: selectedDate)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didFailReminderCreation() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            let alert = UIAlertController(title: "Oops", message: "Não foi possivel criar o lembrete", preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }
}

extension AddReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleReminderTextField {
            dateReminderTextField.becomeFirstResponder()
        }
        return true
    }
}
