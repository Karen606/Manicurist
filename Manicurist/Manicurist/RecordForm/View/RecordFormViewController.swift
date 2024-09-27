//
//  RecordFormViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit
import Combine

class RecordFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet var textFields: [BaseTextField]!
    @IBOutlet var editIcons: [UIImageView]!
    
    @IBOutlet var fieldRightConsts: [NSLayoutConstraint]!
    
    //    @IBOutlet var fieldsRightConsts: [NSLayoutConstraint]!
//    @IBOutlet var editConsts: [NSLayoutConstraint]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var typeTextField: BaseTextField!
    @IBOutlet weak var designTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var timeTextField: BaseTextField!
    @IBOutlet weak var dateArrow: UIImageView!
    @IBOutlet weak var timeArropUp: UIImageView!
    @IBOutlet weak var timeArrowDown: UIImageView!
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    private let viewModel = RecordFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        setNavigationCancelButton()
        setNavigationMenuButton()
        saveButton.addShadow()
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = false
        saveButton.setTitleColor(.baseText, for: .normal)
        saveButton.setTitleColor(.disableText, for: .disabled)
        saveButton.titleLabel?.font = .modernoMedium(size: 24)
        saveButton.isEnabled = false
        textFields.forEach({ $0.delegate = self })
        phoneNumberTextField.baseDelegate = self
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        datePicker.tintColor = .baseRed
        timePicker.locale = NSLocale.current
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(sender:)), for: .valueChanged)
        timePicker.tintColor = .black
        dateTextField.inputView = datePicker
        timeTextField.inputView = timePicker
        registerKeyboardNotifications()
    }
    
    func subscribe() {
        viewModel.$record
            .receive(on: DispatchQueue.main)
            .sink { [weak self] record in
                guard let self = self else { return }
                self.saveButton.isEnabled = (self.textFields.validate() && (phoneNumberTextField.text?.isValidPhoneNumber() ?? false) && (emailTextField.text?.isValidEmail() ?? false))
            }
            .store(in: &cancellables)
        
        viewModel.$isEditing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEditing in
                guard let self = self else { return }
                if isEditing {
                    editIcons.forEach({ $0.isHidden = false })
                    textFields.forEach { field in
                        if field != self.dateTextField && field != self.timeTextField {
                            field.padding.right = 47
                        }
                    }
                    self.nameTextField.text = viewModel.record.name
                    self.emailTextField.text = viewModel.record.email
                    self.phoneNumberTextField.text = viewModel.record.phoneNumber
                    self.typeTextField.text = viewModel.record.type
                    self.designTextField.text = viewModel.record.design
                    self.dateTextField.text = viewModel.record.date?.dateFormat()
                    self.timeTextField.text = viewModel.record.time?.timeFormat()
                    self.saveButton.isEnabled = (self.textFields.validate() && (phoneNumberTextField.text?.isValidPhoneNumber() ?? false) && (emailTextField.text?.isValidEmail() ?? false))
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        let hourDate = sender.date
        let hourFormmater = DateFormatter()
        hourFormmater .locale = Locale.current
        hourFormmater.dateFormat = "HH.mm"
        let formatedTime = hourFormmater.string(from: hourDate)
        timeTextField.text = formatedTime
        viewModel.record.time = sender.date
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let hourDate = sender.date
        let hourFormmater = DateFormatter()
        hourFormmater .locale = Locale.current
        hourFormmater.dateFormat = "dd/MM/YYYY"
        let formatedDate = hourFormmater.string(from: hourDate)
        dateTextField.text = formatedDate
        viewModel.record.date = sender.date
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] success in
            guard let self = self else { return }
            if success {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension RecordFormViewController: UITextFieldDelegate, PhoneNumberTextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.record.name = textField.text
        case phoneNumberTextField:
            viewModel.record.phoneNumber = textField.text
        case emailTextField:
            viewModel.record.email = textField.text
        case typeTextField:
            viewModel.record.type = textField.text
        case designTextField:
            viewModel.record.design = textField.text
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case phoneNumberTextField:
            phoneNumberTextField.isValidPhoneNumber()
        case emailTextField:
            emailTextField.isValidEmail()
        case dateTextField:
            dateArrow.isHighlighted = false
        case timeTextField:
            timeArropUp.isHighlighted = false
            timeArrowDown.isHighlighted = false
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case dateTextField:
            dateArrow.isHighlighted = true
        case timeTextField:
            timeArropUp.isHighlighted = true
            timeArrowDown.isHighlighted = true
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField || textField == timeTextField {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension RecordFormViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(RecordFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
