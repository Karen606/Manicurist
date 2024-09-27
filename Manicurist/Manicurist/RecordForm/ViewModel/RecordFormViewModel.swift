//
//  RecordFormViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import Foundation

class RecordFormViewModel {
    static let shared = RecordFormViewModel()
    @Published var record: RecordModel = RecordModel()
    @Published var isEditing = false
    
    private init() {}
    
    func save(completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.saveRecord(recordModel: record) { error in
            if error == nil {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    func clear() {
        record = RecordModel()
        isEditing = false
    }
}
