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
                    let recordlModel = RecordModel(id: result.id, name: result.name, email: result.email, phoneNumber: result.phone, type: result.typeOfManicure, design: result.designAndColor, date: result.date, time: result.time)         
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
                record.name = recordModel?.name
                record.email = recordModel?.email
                record.phone = recordModel?.phoneNumber
                record.typeOfManicure = recordModel?.type
                record.designAndColor = recordModel?.design
                record.date = recordModel?.date
                record.time = recordModel?.time
                try backgroundContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func removeRecord(id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let recordToDelete = results.first {
                    backgroundContext.delete(recordToDelete)
                    try backgroundContext.save()
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
                    let materialModel = MaterialModel(id: result.id, photo: result.photo, title: result.title)
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
                try backgroundContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
