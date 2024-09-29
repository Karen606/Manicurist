//
//  StocksOfMaterialsViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 29.09.24.
//

import Foundation

class StocksOfMaterialsViewModel {
    static let shared = StocksOfMaterialsViewModel()
    @Published var materials: [MaterialModel] = []
    @Published var outOfStocksMaterials: [MaterialModel] = []
    
    private init() {}
    
    func fetchMaterials() {
        CoreDataManager.shared.fetchMaterials { [weak self] data, error in
            guard let self = self else { return }
            self.materials = data
            self.outOfStocksMaterials = self.materials.filter({ $0.count < 2 })
        }
    }
    
    func increment(id: UUID) {
        CoreDataManager.shared.incrementMaterialCount(by: id) { error in
        }
    }
    
    func decrement(id: UUID) {
        CoreDataManager.shared.decrementMaterialCount(by: id) { error in
        }
    }
    
    func clear() {
        materials = []
        outOfStocksMaterials = []
    }
}
