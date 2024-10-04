//
//  ReportsCollectionViewCell.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 30.09.24.
//

import UIKit

class ReportsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var expensessView: UIView!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var fact: UILabel!
    @IBOutlet weak var expensses: UILabel!
    @IBOutlet weak var records: UILabel!
    @IBOutlet weak var recordsMonth: UILabel!
    @IBOutlet weak var entries: UILabel!
    @IBOutlet weak var monthlyEntries: UILabel!
    @IBOutlet weak var cancel: UILabel!
    @IBOutlet weak var cancelCount: UILabel!
    @IBOutlet weak var cancelProgress: ProgressView!
    @IBOutlet weak var expenssesTitle: UILabel!
    @IBOutlet weak var expenssesMonth: UILabel!
    @IBOutlet weak var rent: UILabel!
    @IBOutlet weak var rentPrice: UILabel!
    @IBOutlet weak var tools: UILabel!
    @IBOutlet weak var toolsPrice: UILabel!
    @IBOutlet weak var materials: UILabel!
    @IBOutlet weak var materialsPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        income.font = .medium(size: 18)
        month.font = .medium(size: 18)
        totalPrice.font = .medium(size: 32)
        fact.font = .medium(size: 16)
        expensses.font = .medium(size: 16)
        records.font = .medium(size: 18)
        recordsMonth.font = .medium(size: 18)
        entries.font = .medium(size: 32)
        monthlyEntries.font = .medium(size: 16)
        cancel.font = .medium(size: 14)
        cancelCount.font = .medium(size: 16)
        expensses.font = .medium(size: 18)
        expenssesMonth.font = .medium(size: 18)
        rent.font = .regular(size: 14)
        rentPrice.font = .medium(size: 14)
        tools.font = .regular(size: 14)
        toolsPrice.font = .medium(size: 14)
        materials.font = .regular(size: 14)
        materialsPrice.font = .medium(size: 14)
    }
}
