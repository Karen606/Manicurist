//
//  RootViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 14.05.25.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
        self.navigationController?.viewControllers = [menu]
    }
}
