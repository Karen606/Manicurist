//
//  MaterialFormViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import Foundation

class MaterialFormViewModel {
    static let shared = MaterialFormViewModel()
    @Published var materialModel = MaterialModel()
    @Published var isEditing = false
    private init() {}
    
    func save(completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.saveMaterial(materialModel: materialModel) { error in
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    func clear() {
        materialModel = MaterialModel()
        isEditing = false
    }
}
