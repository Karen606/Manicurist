//
//  OutOfMaterialsViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import UIKit

class OutOfMaterialsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var materialsTextView: UITextView!
    @IBOutlet weak var textViewHeightConst: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.5445518494, green: 0.5416210294, blue: 0.5668382645, alpha: 1).withAlphaComponent(0.8)
        titleLabel.text = "The following positions\nend:"
        var materials = ""
        for material in StocksOfMaterialsViewModel.shared.outOfStocksMaterials {
            if let name = material.title {
                materials += "-\(name)\n"
            }
        }
        materialsTextView.text = materials
        
    }
    
    override func viewDidLayoutSubviews() {
        let safeAreaHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 48
        if materialsTextView.contentSize.height > textViewHeightConst.constant {
            textViewHeightConst.constant = (materialsTextView.contentSize.height > safeAreaHeight) ? safeAreaHeight : materialsTextView.contentSize.height
        }
    }

    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
