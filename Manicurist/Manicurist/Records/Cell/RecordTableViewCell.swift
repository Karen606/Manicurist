//
//  RecordTableViewCell.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

protocol RecordTableViewCellDelegate: AnyObject {
    func updateStatus(id: UUID, status: Status)
}

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
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
        switch record.status {
        case .active:
            completedButton.isHidden = false
            completedButton.isUserInteractionEnabled = true
            cancelButton.isHidden = false
            cancelButton.isUserInteractionEnabled = true
            self.bgView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        case .canceled:
            completedButton.isHidden = true
            cancelButton.isHidden = false
            cancelButton.isUserInteractionEnabled = false
            self.bgView.backgroundColor = .statusCanceled
        case .completed:
            cancelButton.isHidden = true
            completedButton.isHidden = false
            completedButton.isUserInteractionEnabled = false
            self.bgView.backgroundColor = .statusCompleted
        }
        nameLabel.text = record.name
        typeLabel.text = record.type
        dateLabel.text = record.date?.dateFormat()
        timeLabel.text = record.time?.timeFormat()
        phoneNumberLabel.text = record.phoneNumber
        self.id = record.id
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        if let id = id {
            delegate?.updateStatus(id: id, status: .canceled)
        }
    }
    
    @IBAction func clickedComplete(_ sender: UIButton) {
        if let id = id {
            delegate?.updateStatus(id: id, status: .completed)
        }
    }
}
