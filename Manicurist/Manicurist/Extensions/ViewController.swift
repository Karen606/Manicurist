//
//  ViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

extension UIViewController {
    func setNavigationBar(leftButton: UIButton? = nil, rightButton: UIButton? = nil) {
        if let leftButton = leftButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        }
        if let rightButton = rightButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
    }
    
    @objc func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}
