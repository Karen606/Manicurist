//
//  ExpensesViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 03.10.24.
//

import Foundation

class ExpensesViewModel {
    @Published var expenses = ExpensesModel()
        
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveExpense(expensesModel: expenses) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
