//
//  MenuViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 26.09.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var bottomButtons: [UIButton]!
    @IBOutlet weak var bottomStackView: UIStackView!
    let infoButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoButton.setImage(UIImage(named: "Info"), for: .normal)
        infoButton.addTarget(self, action: #selector(openInfo), for: .touchUpInside)
        self.setNavigationBar(rightButton: infoButton)
        bottomStackView.layer.cornerRadius = 10
        bottomStackView.layer.masksToBounds = true
        bottomButtons.forEach { button in
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = .modernoMedium(size: 16)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let topShadow = EdgeShadowLayer(forView: bottomStackView, edge: .Top)
        bottomStackView.layer.addSublayer(topShadow)
    }
    
    @objc func openInfo() {
        let infoVC = InfoViewController(nibName: "InfoViewController", bundle: nil)
        infoVC.modalPresentationStyle = .overFullScreen
        infoVC.completion = { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = .background
            self.bottomStackView.removeBlurEffect()
        }
        self.present(infoVC, animated: false, completion: { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.4666666667, blue: 0.4941176471, alpha: 1)
            self.bottomStackView.addBlurEffect()
        })
    }
    
    @IBAction func clickedRecordManagment(_ sender: UIButton) {
        let recordsVC = RecordsViewController(nibName: "RecordsViewController", bundle: nil)
        self.navigationController?.pushViewController(recordsVC, animated: true)
    }
    
    @IBAction func clickedCatalog(_ sender: UIButton) {
        let tabBar = UIStoryboard(name: "TabBar", bundle: .main).instantiateViewController(withIdentifier: "TabBarController")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = tabBar
//                UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
    }
    
    @IBAction func clickedMaterials(_ sender: UIButton) {
        let recordsVC = StocksOfMaterialsViewController(nibName: "StocksOfMaterialsViewController", bundle: nil)
        self.navigationController?.pushViewController(recordsVC, animated: true)
    }
}
