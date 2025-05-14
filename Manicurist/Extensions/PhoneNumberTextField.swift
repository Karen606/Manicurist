//
//  PhoneNumberTextField.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

protocol PhoneNumberTextFieldDelegate: AnyObject {
    func textFieldDidChangeSelection(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
}

class PhoneNumberTextField: BaseTextField, UITextFieldDelegate {
    weak var baseDelegate: PhoneNumberTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phoneNumberCommonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        phoneNumberCommonInit()
    }
    
    private func phoneNumberCommonInit() {
        self.delegate = self
        self.keyboardType = .numberPad
    }
    
    private func format(with mask: String, phoneNumber: String) -> String {
        let numbers = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "x" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+x xxx xxx xx xx", phoneNumber: newString)
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        baseDelegate?.textFieldDidChangeSelection(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        baseDelegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        baseDelegate?.textFieldDidEndEditing(textField)
    }
    
    func isValidPhoneNumber() {
        self.showError(error: (text?.isValidPhoneNumber() ?? false) ? nil : "Phone number must be at least 10 numbers")
    }
}
