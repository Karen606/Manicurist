//
//  RecordTableViewCell.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

protocol RecordTableViewCellDelegate: AnyObject {
    func removeRecord(id: UUID)
}

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    private var id: UUID?
    weak var delegate: RecordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let labels = [nameLabel, typeLabel, dateLabel, phoneNumberLabel, timeLabel]
        labels.forEach({ $0?.font = .medium(size: 18)})
        self.bgView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        self.bgView.layer.cornerRadius = 20
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        id = nil
    }
    
    func setupContent(record: RecordModel) {
        nameLabel.text = record.name
        typeLabel.text = record.type
        dateLabel.text = record.date?.dateFormat()
        timeLabel.text = record.time?.timeFormat()
        phoneNumberLabel.text = record.phoneNumber
        self.id = record.id
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        if let id = id {
            delegate?.removeRecord(id: id)
        }
    }
    
}
