//
//  TextInputCell.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 5/11/2022.
//

import UIKit

protocol TextInputCellDelegate: AnyObject {

    func cell(_ cell: TextInputCell, didChangeValue value: String?)
    func cell(_ cell: TextInputCell, didEndEditing value: String?)
}

class TextInputCell: UITableViewCell {

    private struct Constants {
        static let inset:CGFloat = 16.0
        static let fontSize:CGFloat = 16.0
    }
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.fontSize)
        return label
    }()
    private(set) var textField = UITextField()
    
    var cellID: String? { titleLabel.text }
    
    weak var delegate: TextInputCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate(
            setupTitle() +
            setupTextfield()
        )
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitle() -> [NSLayoutConstraint] {
        
        titleLabel.layer.opacity = 0.7
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.inset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 1.0, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        return constraints
    }
    
    private func setupTextfield() -> [NSLayoutConstraint] {
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.inset),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.inset),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            
        ]
        
        return constraints
    }
    
    func configure(textInputField: TextInputField) {
        
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldEditingEnded), for: .editingDidEnd)
        
        titleLabel.text = textInputField.nameText
        textField.text = textInputField.inputValue ?? ""
        textField.placeholder = textInputField.placeholderText ?? ""
        
        setValidity(textInputField.validity)
    }
    
    private func setValidity(_ validity: TextInputField.Validity) {
        
        switch validity {
        case .invalid:
            titleLabel.textColor = .themeInvalid
            textField.textColor = .themeInvalid
            
        default:
            titleLabel.textColor = .themeForeground
            textField.textColor = .themeForeground
        }
        
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        delegate?.cell(self, didChangeValue: textField.text)
    }
    
    @objc private func textFieldEditingEnded(_ textField: UITextField) {
        delegate?.cell(self, didEndEditing: textField.text)
    }
}
