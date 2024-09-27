//
//  InfoViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var infoView: UIView!
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background.withAlphaComponent(0)
        infoView.addShadow()
        buttons.forEach({ $0.titleLabel?.font = .modernoMedium(size: 16)})
    }
    
    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: completion)
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
