//
//  CustomTableViewCell.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var remindersModel: RemindersModel?
    var didPressComplete: (() -> Void) = {}

    private lazy var checkboxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = makeImage("circle")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        button.tintColor = .systemPurple
        return button
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var titleReminderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    private lazy var dateReminderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()

    var isChecked: Bool = false {
        didSet {
            let imageCircleFill = makeImage("circle.fill")
            let imageCircle = makeImage("circle")
            let checkboxImage = isChecked ? imageCircleFill : imageCircle
            checkboxButton.setImage(checkboxImage, for: .normal)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        labelsStackView.addArrangedSubview(titleReminderLabel)
        labelsStackView.addArrangedSubview(dateReminderLabel)
        contentView.addSubview(checkboxButton)
        contentView.addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 40),
            checkboxButton.heightAnchor.constraint(equalToConstant: 40),
            
            labelsStackView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    @objc
    private func checkboxButtonTapped() {
        isChecked.toggle()
        didPressComplete()
    }
    
    func passData(_ data: RemindersModel) {
        titleReminderLabel.text = data.title
        dateReminderLabel.text = data.date.toString()
        isChecked = data.isCompleted
    }
    
    private func makeImage(_ name: String) -> UIImage? {
        let image = UIImage(systemName: name)
        let formattedImage = image?.withTintColor(.systemPurple).resizeTo(25)
        return formattedImage
    }
    
    
}
