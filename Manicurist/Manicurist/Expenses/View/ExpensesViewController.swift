//
//  ExpensesViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 03.10.24.
//

import UIKit
import Combine

class ExpensesViewController: UIViewController {

    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var rentTextField: PriceTextField!
    @IBOutlet weak var toolsTextField: PriceTextField!
    @IBOutlet weak var materialsTextField: PriceTextField!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    private let datePicker = UIDatePicker()
    private let viewModel = ExpensesViewModel()
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationCancelButton()
        setNavigationMenuButton()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        saveButton.addShadow()
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = false
        saveButton.setTitleColor(.baseText, for: .normal)
        saveButton.setTitleColor(.disableText, for: .disabled)
        saveButton.titleLabel?.font = .modernoMedium(size: 24)
        saveButton.isEnabled = false
        dateTextField.delegate = self
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        let textFields = [rentTextField, toolsTextField, materialsTextField]
        textFields.forEach { textField in
            textField?.priceDelegate = self
            textField?.layer.cornerRadius = 8
            textField?.attributedPlaceholder = NSAttributedString(string: textField?.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.5607843137, green: 0.5490196078, blue: 0.5490196078, alpha: 1), NSAttributedString.Key.font: UIFont.italicMedium(size: 12)])
            textField?.font = .medium(size: 12)
        }
        dateTextField.inputView = datePicker
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let hourDate = sender.date
        let hourFormmater = DateFormatter()
        hourFormmater .locale = Locale.current
        hourFormmater.dateFormat = "dd/MM/YYYY"
        let formatedDate = hourFormmater.string(from: hourDate)
        dateTextField.text = formatedDate
        viewModel.expenses.date = sender.date
    }
    
    func subscribe() {
        viewModel.$expenses
            .receive(on: DispatchQueue.main)
            .sink { [weak self] expenses in
                guard let self = self else { return }
                self.saveButton.isEnabled = (expenses.date != nil) && (self.toolsTextField.isValidPrice() || self.rentTextField.isValidPrice() || self.materialsTextField.isValidPrice())
                self.totalExpensesLabel.text = "\((expenses.materials ?? 0) + (expenses.tools ?? 0) + (expenses.rent ?? 0))$"
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
//        viewModel.clear()
    }
}

extension ExpensesViewController: PriceTextFielddDelegate, UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case rentTextField:
            viewModel.expenses.rent = rentTextField.formatNumber()
        case toolsTextField:
            viewModel.expenses.tools = toolsTextField.formatNumber()
        case materialsTextField:
            viewModel.expenses.materials = materialsTextField.formatNumber()
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty && value.last == "$" else { return }
        switch textField {
        case rentTextField:
            rentTextField.text?.removeLast()
        case toolsTextField:
            toolsTextField.text?.removeLast()
        case materialsTextField:
            materialsTextField.text?.removeLast()
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty else { return }
        switch textField {
        case rentTextField:
            rentTextField.text! += "$"
        case toolsTextField:
            toolsTextField.text! += "$"
        case materialsTextField:
            materialsTextField.text! += "$"
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            return false
        }
        return true
    }
}
