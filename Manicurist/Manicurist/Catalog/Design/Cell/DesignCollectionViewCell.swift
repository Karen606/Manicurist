//
//  DesignCollectionViewCell.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import UIKit

class DesignCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        descriptionLabel.layer.borderWidth = 0.5
        descriptionLabel.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.4431372549, blue: 0.831372549, alpha: 1)
        descriptionLabel.layer.cornerRadius = 3
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.leftInset = 4
        descriptionLabel.rightInset = 4
        descriptionLabel.font = .medium(size: 10)
    }
    
    func setupDate(designModel: DesignModel) {
        if let data = designModel.photo {
            imageView.image = UIImage(data: data)
        }
        descriptionLabel.text = designModel.title
    }
    
    func setupMaterial(materialModel: MaterialModel) {
        if let data = materialModel.photo {
            imageView.image = UIImage(data: data)
        }
        descriptionLabel.text = materialModel.title
    }

}
