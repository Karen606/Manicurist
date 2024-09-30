//
//  TabBarController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let customTabBar = tabBar as? CustomTabBar {
            UIView.animate(withDuration: 0.3) {
                customTabBar.layoutSubviews()
            }
        }
    }
}

import UIKit

class CustomTabBar: UITabBar {
    private var firstItemLabel: UILabel?
    private var secondItemlabel: UILabel?

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        
        if let item = self.items?.first {
            if let view = item.value(forKey: "view") as? UIView {
                customizeTabBarItem(view: view, isSelected: item == selectedItem, index: 0)
            }
        }
        
        if let item = self.items?.last {
            if let view = item.value(forKey: "view") as? UIView {
                customizeTabBarItem(view: view, isSelected: item == selectedItem, index: 1)
            }
        }
    }
    
    private func customizeTabBarItem(view: UIView, isSelected: Bool, index: Int) {
        var width = self.bounds.width / 2
        self.layer.masksToBounds = false
        view.backgroundColor = .baseYellow
        view.layer.masksToBounds = true
        var frame = view.frame
        frame.size.height = 100
        frame.size.width = width
        frame.origin.y = isSelected ? -12 : 0
        frame.origin.x = (index == 0) ? 0 : width
        view.frame = frame
        if !(view.layer.sublayers?.contains(where: { $0 is EdgeShadowLayer }) ?? false) {
            let topShadow = EdgeShadowLayer(forView: view, edge: .Top)
            view.layer.addSublayer(topShadow)
        }
        
        if index == 0 {
            firstItemLabel?.font = isSelected ? .modernoRegular(size: 20) : .modernoRegular(size: 16)
            let corners: UIRectCorner = isSelected ? [.topLeft, .topRight] : [.topLeft]
            view.roundCorners(corners, radius: 10)
        } else {
            secondItemlabel?.font = isSelected ? .modernoRegular(size: 20) : .modernoRegular(size: 16)
            let corners: UIRectCorner = isSelected ? [.topLeft, .topRight] : [.topRight]
            view.roundCorners(corners, radius: 10)
        }
        
        if index == 0 && firstItemLabel == nil {
            firstItemLabel = UILabel()
            guard let firstItemLabel = firstItemLabel else { return }
            firstItemLabel.text = "Manicure\ndesign"
            firstItemLabel.numberOfLines = 2
            firstItemLabel.font = .modernoRegular(size: 20)
            firstItemLabel.textColor = .baseText
            firstItemLabel.textAlignment = .center
            firstItemLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(firstItemLabel)
            NSLayoutConstraint.activate([
                firstItemLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                firstItemLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                firstItemLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                firstItemLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
            ])
        } else if index == 1 && secondItemlabel == nil {
            secondItemlabel = UILabel()
            guard let secondItemLabel = secondItemlabel else { return }
            secondItemLabel.text = "Catalog\nof materials"
            secondItemLabel.numberOfLines = 2
            secondItemLabel.font = .modernoRegular(size: 20)
            secondItemLabel.textColor = .baseText
            secondItemLabel.textAlignment = .center
            secondItemLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(secondItemLabel)
            NSLayoutConstraint.activate([
                secondItemLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                secondItemLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                secondItemLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                secondItemLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
            ])
        }

    }
}
