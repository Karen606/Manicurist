//
//  DesignFormViewMode.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import Foundation

class DesignFormViewModel {
    static let shared = DesignFormViewModel()
    @Published var designModel = DesignModel()
    private init() {}
    
    func save(completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.saveDesign(designModel: designModel) { error in
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    func clear() {
        designModel = DesignModel()
    }
}
