//
//  DesignViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import UIKit
import Combine

class DesignViewController: UIViewController {

    @IBOutlet weak var designsCollectionView: UICollectionView!
    private let viewModel = DesignsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        viewModel.fetchDesings()
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
        layout.minimumInteritemSpacing = 26
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        designsCollectionView.collectionViewLayout = layout
        designsCollectionView.register(UINib(nibName: "DesignCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DesignCollectionViewCell")
        designsCollectionView.register(UINib(nibName: "AddDesignCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddDesignCollectionViewCell")
        designsCollectionView.delegate = self
        designsCollectionView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$designs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] desings in
                guard let self = self else { return }
                self.designsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension DesignViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.designs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == viewModel.designs.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDesignCollectionViewCell", for: indexPath) as! AddDesignCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DesignCollectionViewCell", for: indexPath) as! DesignCollectionViewCell
            cell.setupDate(designModel: viewModel.designs[indexPath.item])
            return cell
        }
    }
    
}

extension DesignViewController: AddDesignCollectionViewCellDelegate {
    func addDesign() {
        let designFormVC = DesignFormViewController(nibName: "DesignFormViewController", bundle: nil)
        designFormVC.completion = { [weak self] in
            if let self = self {
                viewModel.fetchDesings()
            }
        }
        self.navigationController?.pushViewController(designFormVC, animated: true)
    }
}
