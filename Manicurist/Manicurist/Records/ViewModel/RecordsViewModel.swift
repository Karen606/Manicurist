//
//  RecordsViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import Foundation

class RecordsViewModel {
    static let shared = RecordsViewModel()
    private var records: [RecordModel] = []
    @Published var filteredRecords: [RecordModel] = []
    var search: String?
    
    private init() {}
    
    func filter(by value: String?) {
        self.search = value
        if let value = value, !value.isEmpty {
            filteredRecords = records.filter { ($0.name ?? "").localizedCaseInsensitiveContains(value) }
        } else {
            filteredRecords = records
        }
    }
    
    func fetchRecords() {
        CoreDataManager.shared.fetchRecords { [weak self] records, error in
            guard let self = self else { return }
            self.records = records
            self.filter(by: search)
        }
    }
    
    func removeRecord(id: UUID) {
        CoreDataManager.shared.removeRecord(id: id) { [weak self] error in
            guard let self = self else { return }
            self.fetchRecords()
        }
    }
}
