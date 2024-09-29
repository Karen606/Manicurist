//
//  AddDesignCollectionViewCell.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import UIKit

protocol AddDesignCollectionViewCellDelegate: AnyObject {
    func addDesign()
}

class AddDesignCollectionViewCell: UICollectionViewCell {
    weak var delegate: AddDesignCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func clickedAdd(_ sender: UIButton) {
        delegate?.addDesign()
    }
}
