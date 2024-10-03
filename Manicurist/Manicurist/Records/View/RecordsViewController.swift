//
//  RecordsViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit
import Combine

class RecordsViewController: UIViewController {

    @IBOutlet weak var searchTextField: BaseTextField!
    @IBOutlet weak var addClientBgView: UIView!
    @IBOutlet weak var addNewClientButton: UIButton!
    @IBOutlet weak var recordsTableView: UITableView!
    private let viewModel = RecordsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchRecords()
    }
    
    func setupUI() {
        setNavigationMenuButton()
        setNavigationCancelButton()
        searchTextField.delegate = self
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
    }
    
    func subscribe() {
        viewModel.$filteredRecords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                self.addClientBgView.isHidden = !records.isEmpty
                self.recordsTableView.isHidden = records.isEmpty
                self.recordsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func addClient() {
        let recordFomrVC = RecordFormViewController(nibName: "RecordFormViewController", bundle: nil)
        recordFomrVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchRecords()
        }
        self.navigationController?.pushViewController(recordFomrVC, animated: true)
    }
    
    @IBAction func clickedAddClient(_ sender: UIButton) {
        let recordFomrVC = RecordFormViewController(nibName: "RecordFormViewController", bundle: nil)
        recordFomrVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchRecords()
        }
        self.navigationController?.pushViewController(recordFomrVC, animated: true)
    }
    
    deinit {
        viewModel.search = nil
    }
}

extension RecordsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.filteredRecords.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        cell.setupContent(record: viewModel.filteredRecords[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.filteredRecords.count - 1 == section {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "Add"), for: .normal)
            button.addTarget(self, action: #selector(addClient), for: .touchUpInside)
            button.frame = CGRect(x: (footerView.frame.width - 30) / 2, y: (footerView.frame.height - 30) / 2, width: 30, height: 30)
            footerView.addSubview(button)
            return footerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.filteredRecords.count - 1 == section ? 60 : 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordFomrVC = RecordFormViewController(nibName: "RecordFormViewController", bundle: nil)
        RecordFormViewModel.shared.record = viewModel.filteredRecords[indexPath.section]
        recordFomrVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchRecords()
        }
        RecordFormViewModel.shared.isEditing = true
        self.navigationController?.pushViewController(recordFomrVC, animated: true)
    }
}

extension RecordsViewController: RecordTableViewCellDelegate {
    func updateStatus(id: UUID, status: Status) {
        viewModel.updateStatus(id: id, status: status)
    }
}

extension RecordsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.filter(by: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
