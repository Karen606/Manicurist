//
//  MaterialsViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import Foundation

class MaterialsViewModel {
    static let shared = MaterialsViewModel()
    @Published var materials: [MaterialModel] = []
    private init() {}
    
    func fetchMaterials() {
        CoreDataManager.shared.fetchMaterials { data, error in
            var materials = data
            materials.append(MaterialModel())
            self.materials = materials
        }
    }
}
