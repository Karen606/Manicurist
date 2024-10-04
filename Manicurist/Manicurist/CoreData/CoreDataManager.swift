//
//  CoreDataManager.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Manicurist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchRecords(completion: @escaping ([RecordModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var recordModels: [RecordModel] = []
                for result in results {
                    let recordlModel = RecordModel(status: .status(value: result.status ?? ""), id: result.id, name: result.name, email: result.email, phoneNumber: result.phone, type: result.typeOfManicure, design: result.designAndColor, date: result.date, time: result.time, price: result.price)         
                    recordModels.append(recordlModel)
                }
                completion(recordModels, nil)
            } catch {
                completion([], error)
            }
        }
    }
    
    func saveRecord(recordModel: RecordModel?, completion: @escaping (Error?) -> Void) {
        let id = recordModel?.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let record: Record

                if let existingMaterial = results.first {
                    record = existingMaterial
                } else {
                    record = Record(context: backgroundContext)
                    record.id = id
                }
                record.status = recordModel?.status.id
                record.name = recordModel?.name
                record.email = recordModel?.email
                record.phone = recordModel?.phoneNumber
                record.typeOfManicure = recordModel?.type
                record.designAndColor = recordModel?.design
                record.date = recordModel?.date
                record.time = recordModel?.time
                record.price = recordModel?.price ?? 0
                try backgroundContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func updateRecordStatus(id: UUID, newStatus: String, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let recordToUpdate = results.first {
                    recordToUpdate.status = newStatus // Update the status here
                    try backgroundContext.save() // Save the context with the updated status
                    completion(nil)
                } else {
                    let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Record not found"])
                    completion(error)
                }
            } catch {
                completion(error)
            }
        }
    }
    
    func fetchDesigns(completion: @escaping ([DesignModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Design> = Design.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var designModels: [DesignModel] = []
                for result in results {
                    let designModel = DesignModel(id: result.id, photo: result.photo, title: result.title)
                    designModels.append(designModel)
                }
                completion(designModels, nil)
            } catch {
                completion([], error)
            }
        }
    }
    
    func saveDesign(designModel: DesignModel?, completion: @escaping (Error?) -> Void) {
        let id = designModel?.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Design> = Design.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let design: Design

                if let existingMaterial = results.first {
                    design = existingMaterial
                } else {
                    design = Design(context: backgroundContext)
                    design.id = id
                }
                design.photo = designModel?.photo
                design.title = designModel?.title
                try backgroundContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func fetchMaterials(completion: @escaping ([MaterialModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var materialModels: [MaterialModel] = []
                for result in results {
                    let materialModel = MaterialModel(id: result.id, photo: result.photo, title: result.title, count: result.count)
                    materialModels.append(materialModel)
                }
                completion(materialModels, nil)
            } catch {
                completion([], error)
            }
        }
    }
    
    func saveMaterial(materialModel: MaterialModel?, completion: @escaping (Error?) -> Void) {
        let id = materialModel?.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let material: Material

                if let existingMaterial = results.first {
                    material = existingMaterial
                } else {
                    material = Material(context: backgroundContext)
                    material.id = id
                }
                material.photo = materialModel?.photo
                material.title = materialModel?.title
                material.count = materialModel?.count ?? 1
                try backgroundContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func incrementMaterialCount(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let material = results.first {
                    material.count += 1
                    try backgroundContext.save()
                    completion(nil)
                } else {
                    completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Material not found"]))
                }
            } catch {
                completion(error)
            }
        }
    }

    func decrementMaterialCount(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let material = results.first {
                    if material.count > 0 {
                        material.count -= 1
                        try backgroundContext.save()
                        completion(nil)
                    } else {
                        completion(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Material count is already zero"]))
                    }
                } else {
                    completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Material not found"]))
                }
            } catch {
                completion(error)
            }
        }
    }
    
    func saveExpense(expensesModel: ExpensesModel?, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date == %@", expensesModel?.date as NSDate? ?? NSDate())
            do {
                let existingExpenses = try backgroundContext.fetch(fetchRequest)
                
                if let existingExpense = existingExpenses.first {
                    existingExpense.rent = (expensesModel?.rent ?? 0.0) + (existingExpense.rent)
                    existingExpense.tools = (expensesModel?.tools ?? 0.0) + (existingExpense.tools)
                    existingExpense.materials = (expensesModel?.materials ?? 0.0) + (existingExpense.materials)
                } else {
                    let newExpense = Expenses(context: backgroundContext)
                    newExpense.date = expensesModel?.date
                    newExpense.rent = expensesModel?.rent ?? 0.0
                    newExpense.tools = expensesModel?.tools ?? 0.0
                    newExpense.materials = expensesModel?.materials ?? 0.0
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchExpenses(completion: @escaping ([ExpensesModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
            do {
                let fetchedExpenses = try backgroundContext.fetch(fetchRequest)
                let expenses = fetchedExpenses.map { entity -> ExpensesModel in
                    return ExpensesModel(
                        date: entity.date,
                        rent: entity.rent,
                        tools: entity.tools,
                        materials: entity.materials
                    )
                }
                DispatchQueue.main.async {
                    completion(expenses, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }

}
