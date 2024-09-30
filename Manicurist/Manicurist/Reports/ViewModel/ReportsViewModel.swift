//
//  ReportsViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 30.09.24.
//

import Foundation

class ReportsViewModel {
    static let shared = ReportsViewModel()
    @Published var records: [String: [RecordModel]] = [:]
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchRecords { [weak self] records, error in
            guard let self = self else { return }
            self.records = groupRecordsByMonth(records: records)
        }
    }
    
    func groupRecordsByMonth(records: [RecordModel]) -> [String: [RecordModel]] {
        var recordsByMonth: [String: [RecordModel]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        for record in records {
            if let date = record.date {
                let monthKey = dateFormatter.string(from: date)
                if recordsByMonth[monthKey] != nil {
                    recordsByMonth[monthKey]?.append(record)
                } else {
                    recordsByMonth[monthKey] = [record]
                }
            }
        }
        return recordsByMonth
    }

}
