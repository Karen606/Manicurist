//
//  StocksOfMaterialsTableViewCell.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import UIKit

protocol StocksOfMaterialsTableViewCellDelegate: AnyObject {
    func increment(id: UUID)
    func decrement(id: UUID)
}

class StocksOfMaterialsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    private var id: UUID?
    weak var delegate: StocksOfMaterialsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        id = nil
    }
    
    func setupData(material: MaterialModel) {
        nameLabel.text = material.title
        countLabel.text = "\(material.count)"
        self.id = material.id
    }
    
    @IBAction func clickedPlus(_ sender: UIButton) {
        if let id = id {
            delegate?.increment(id: id)
            countLabel.text = "\((Int(countLabel.text ?? "0") ?? 0) + 1)"
        }
    }
    
    @IBAction func clickedMinus(_ sender: UIButton) {
        if let id = id {
            if let value = countLabel.text, Int(value) ?? 0 > 0 {
                delegate?.decrement(id: id)
                countLabel.text = "\((Int(value) ?? 0) - 1)"
            }
        }
    }
}
