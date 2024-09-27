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
    
    func setNavigationCancelButton() {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .medium(size: 18)
        cancelButton.setTitleColor(.baseRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(clickedBackButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    func setNavigationMenuButton() {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(clickedMenu), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    @objc func clickedMenu() {
        if let menuVC = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        }
    }
    
    @objc func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}
