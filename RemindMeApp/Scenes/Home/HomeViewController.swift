//
//  HomeViewController.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 07/02/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var emptyTableViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Adicione lembretes clicando no botão abaixo"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bottomBar: UIToolbar = {
        let bottomBar = UIToolbar()
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { _ in
            self.coordinator.presentAddReminderScreen()
        }
        let image = UIImage.init(systemName: "plus")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let plusButton = UIBarButtonItem(title: nil, image: image, primaryAction: action)
        plusButton.tintColor = .purple
        let button = UIBarButtonItem(title: "Adicionar lembrete", image: nil, primaryAction: action)
        button.tintColor = .purple
        bottomBar.setItems([flexibleSpace, plusButton, button], animated: true)
        return bottomBar
    }()
    
    private lazy var loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let tableView = UITableView()
    private let viewModel: HomeViewModel
    private let coordinator: HomeCoordinator
    
    init(
        viewModel: HomeViewModel,
        coordinator: HomeCoordinator
    ) {
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
        title = "Lista de Lembretes"
        configTableView()
        setupUI()
        verifyIfThereIsValueOnTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyTableViewLabel.isHidden = true
        loading.center = tableView.center
        loading.isHidden = false
        tableView.isHidden = true
        loading.startAnimating()
        viewModel.getReminders()
    }
    
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyTableViewLabel)
        view.addSubview(tableView)
        view.addSubview(loading)
        view.addSubview(bottomBar)

        NSLayoutConstraint.activate([
            emptyTableViewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTableViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            emptyTableViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loading.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "ReminderCellIdentifier")
    }
    
    private func verifyIfThereIsValueOnTableView() {
        let shouldHideTableView = viewModel.remindersDataMatrix.count == 0
        tableView.isHidden = shouldHideTableView
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableview(_tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coordinator.showDeleteCellAlert {
                self.viewModel.removeCell(at: indexPath, isCompleting: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.remindersDataMatrix[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCellIdentifier", for: indexPath) as! CustomTableViewCell
        let element = viewModel.remindersDataMatrix[indexPath.section][indexPath.row]
        cell.passData(element)
        cell.didPressComplete = {
            self.viewModel.removeCell(at: indexPath, isCompleting: true)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.remindersDataMatrix.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getMonthName(section: section)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func showError() {
        let alert = UIAlertController(title: "Oops", message: "Não foi possível recuperar os lembretes", preferredStyle: .alert)
        let okButotn = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButotn)
        present(alert, animated: true)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.emptyTableViewLabel.isHidden = false
            self.loading.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.verifyIfThereIsValueOnTableView()
        }
    }
}

extension HomeViewController: AddReminderControllerDelegate {
    func passRemindersInfo(title: String, date: Date) {
        let newReminder = RemindersModel(title: title, date: date)
        viewModel.appendReminder(newReminder)
    }
}
