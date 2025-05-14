//
//  DesignsViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 28.09.24.
//

import Foundation

class DesignsViewModel {
    static let shared = DesignsViewModel()
    @Published var designs: [DesignModel] = []
    private init() {}
    
    func fetchDesings() {
        CoreDataManager.shared.fetchDesigns { data, error in
            var desings = data
            desings.append(DesignModel())
            self.designs = desings
        }
    }
}
