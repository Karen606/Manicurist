//
//  ReportsViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 30.09.24.
//

import UIKit
import Combine

class ReportsViewController: UIViewController {

    @IBOutlet weak var reportsCollectionView: UICollectionView!
    private let viewModel = ReportsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportsCollectionView.dataSource = self
        reportsCollectionView.delegate = self
        reportsCollectionView.register(UINib(nibName: "ReportsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReportsCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.frame.size.width - 40)
        layout.itemSize = CGSize(width: itemWidth, height: 561)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        reportsCollectionView.collectionViewLayout = layout
    }
    
    func subscribe() {
        viewModel.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                self.reportsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
        
}

extension ReportsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.records.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportsCollectionViewCell", for: indexPath) as! ReportsCollectionViewCell
            return cell
        }
}

class ProgressView: UIProgressView {
    
    var customHeight: CGFloat = 10.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = customHeight
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Apply the transformation to change the height
        let scale = customHeight / intrinsicContentSize.height
        transform = CGAffineTransform(scaleX: 1, y: scale)
    }
}
