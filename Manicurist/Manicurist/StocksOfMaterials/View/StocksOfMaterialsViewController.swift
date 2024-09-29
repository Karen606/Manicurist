//
//  StocksOfMaterialsViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import UIKit
import Combine

class StocksOfMaterialsViewController: UIViewController {

    @IBOutlet weak var materialsTableView: UITableView!
    private let viewModel = StocksOfMaterialsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationFinanceButton()
        setNavigationMenuButton()
        setupTableView()
        subscribe()
        viewModel.fetchMaterials()
    }
    
    func setupTableView() {
        materialsTableView.delegate = self
        materialsTableView.dataSource = self
        materialsTableView.register(UINib(nibName: "StocksOfMaterialsTableViewCell", bundle: nil), forCellReuseIdentifier: "StocksOfMaterialsTableViewCell")
    }

    func subscribe() {
        viewModel.$materials
            .receive(on: DispatchQueue.main)
            .sink { [weak self] materials in
                guard let self = self else { return }
                self.materialsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$outOfStocksMaterials
            .receive(on: DispatchQueue.main)
            .sink { [weak self] outOfStocksMaterials in
                guard let self = self, !outOfStocksMaterials.isEmpty else { return }
                let outOfStocksMaterialsVC = OutOfMaterialsViewController(nibName: "OutOfMaterialsViewController", bundle: nil)
                outOfStocksMaterialsVC.modalPresentationStyle = .overFullScreen
                self.present(outOfStocksMaterialsVC, animated:  false)
            }
            .store(in: &cancellables)
    }
    
    @objc func addMaterial() {
        let materialFormVC = MaterialFormViewController(nibName: "MaterialFormViewController", bundle: nil)
        materialFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchMaterials()
            }
        }
        self.navigationController?.pushViewController(materialFormVC, animated: true)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension StocksOfMaterialsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksOfMaterialsTableViewCell", for: indexPath) as! StocksOfMaterialsTableViewCell
        cell.setupData(material: viewModel.materials[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Add"), for: .normal)
        button.setTitle("Add Material", for: .normal)
        button.titleLabel?.font = .modernoBold(size: 14)
        button.setTitleColor(.baseText, for: .normal)
        button.addTarget(self, action: #selector(addMaterial), for: .touchUpInside)
        button.frame = CGRect(x: (footerView.frame.width - 120) / 2, y: (footerView.frame.height - 30) / 2, width: 120, height: 30)
        footerView.addSubview(button)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let materialFormVC = MaterialFormViewController(nibName: "MaterialFormViewController", bundle: nil)
        materialFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchMaterials()
            }
        }
        MaterialFormViewModel.shared.materialModel = viewModel.materials[indexPath.row]
        MaterialFormViewModel.shared.isEditing = true
        self.navigationController?.pushViewController(materialFormVC, animated: true)
    }
}

extension StocksOfMaterialsViewController: StocksOfMaterialsTableViewCellDelegate {
    func increment(id: UUID) {
        viewModel.increment(id: id)
    }
    
    func decrement(id: UUID) {
        viewModel.decrement(id: id)
    }
}
