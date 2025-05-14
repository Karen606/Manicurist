//
//  ReportsViewModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 30.09.24.
//

import Foundation

class ReportsViewModel {
    static let shared = ReportsViewModel()
    @Published var reportModel: ReportModel = ReportModel()
    var filteredRecords: [RecordModel] = []
    private var filteredExpenses: [ExpensesModel] = []
    private var records: [RecordModel] = []
    private var expenses: [ExpensesModel] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    private init() {
        startDate = firstDayOfMonth() ?? Date()
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchRecords { [weak self] records, error in
            guard let self = self else { return }
            self.records = records
            filterByPeriod(startDate: startDate, endDate: endDate)
        }
        
        CoreDataManager.shared.fetchExpenses { [weak self] expenses, error in
            guard let self = self else { return }
            filteredExpenses = expenses.filter { expense in
                if let expenseDate = expense.date {
                    return expenseDate >= self.startDate && expenseDate <= self.endDate
                }
                return false
            }
            let totalRent = self.filteredExpenses.reduce(0) { (sum, expense) in sum + (expense.rent ?? 0) }
            
            let totalTools = self.filteredExpenses.reduce(0) { (sum, expense) in sum + (expense.tools ?? 0) }
            
            let totalMaterials = self.filteredExpenses.reduce(0) { (sum, expense) in sum + (expense.materials ?? 0) }
            self.reportModel.materials = totalMaterials
            self.reportModel.tools = totalTools
            self.reportModel.rent = totalRent
            self.reportModel.expenses = totalMaterials + totalTools + totalRent
        }
    }
    
    func filterByPeriod(startDate: Date, endDate: Date) {
        filteredRecords = records.filter { record in
            if let recordDate = record.date {
                return recordDate >= startDate && recordDate <= endDate
            }
            return false
        }
        let totalPrice = filteredRecords.filter { $0.status == .completed }
            .reduce(0.0) { $0 + ($1.price ?? 0.0) }
        let canceledRecord = records.filter { $0.status == .canceled }.count
        
        self.reportModel.income = totalPrice
        self.reportModel.records = filteredRecords.count
        self.reportModel.cancelRecords = canceledRecord
        
    }
    
    func firstDayOfMonth() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date()
        if let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) {
            return firstDayOfMonth
        }
        return nil
    }
    
    func clear() {
        reportModel = ReportModel()
        filteredRecords = []
        filteredExpenses = []
        records = []
        expenses = []
        var startDate = Date()
        var endDate = Date()
    }
}

struct ReportModel {
    var income: Double?
    var records: Int?
    var cancelRecords: Int?
    var expenses: Double?
    var rent: Double?
    var tools: Double?
    var materials: Double?
}
