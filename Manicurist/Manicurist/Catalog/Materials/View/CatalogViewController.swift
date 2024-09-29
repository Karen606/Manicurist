//
//  CatalogViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import UIKit
import Combine

class CatalogViewController: UIViewController {
    
    @IBOutlet weak var materialsCollectionView: UICollectionView!
    private let viewModel = MaterialsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        viewModel.fetchMaterials()
        subscribe()
    }
    
    func setupUI() {
        setNavigationMenuButton()
        setNavigationFinanceButton()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let totalSpacing: CGFloat = 30 + 30 + 26
        let itemWidth = (view.frame.size.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        materialsCollectionView.collectionViewLayout = layout
        materialsCollectionView.register(UINib(nibName: "DesignCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DesignCollectionViewCell")
        materialsCollectionView.register(UINib(nibName: "AddDesignCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddDesignCollectionViewCell")
        materialsCollectionView.delegate = self
        materialsCollectionView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$materials
            .receive(on: DispatchQueue.main)
            .sink { [weak self] materials in
                guard let self = self else { return }
                self.materialsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.materials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == viewModel.materials.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDesignCollectionViewCell", for: indexPath) as! AddDesignCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DesignCollectionViewCell", for: indexPath) as! DesignCollectionViewCell
            cell.setupMaterial(materialModel: viewModel.materials[indexPath.item])
            return cell
        }
    }
    
}

extension CatalogViewController: AddDesignCollectionViewCellDelegate {
    func addDesign() {
        let materialFormVC = MaterialFormViewController(nibName: "MaterialFormViewController", bundle: nil)
        materialFormVC.completion = { [weak self] in
            if let self = self {
                viewModel.fetchMaterials()
            }
        }
        self.navigationController?.pushViewController(materialFormVC, animated: true)
    }
}
