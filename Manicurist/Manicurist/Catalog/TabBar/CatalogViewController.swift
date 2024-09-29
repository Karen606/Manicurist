//
//  CatalogViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import UIKit

class CatalogViewController: UIViewController {

    @IBOutlet weak var catalogLabel: UILabel!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet var bottomViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationMenuButton()
        setNavigationFinanceButton()

        designLabel.font = .displayRegular(size: 20)
        designLabel.textColor = .baseText
        catalogLabel.font = .displayRegular(size: 16)
        catalogLabel.textColor = .baseText
    }
    
    override func viewDidLayoutSubviews() {
        bottomViews.forEach { bottomView in
            bottomView.layer.cornerRadius = 10
            bottomView.layer.masksToBounds = true
            let topShadow = EdgeShadowLayer(forView: bottomView, edge: .Top)
            bottomView.layer.addSublayer(topShadow)
        }
    }
}
