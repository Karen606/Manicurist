//
//  BaseButton.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

class BaseButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .baseYellow : .disableYellow
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
