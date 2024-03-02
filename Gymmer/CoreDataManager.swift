//
//  CoreDataManager.swift
//  Gymmer
//
//  Created by Abdullah Ridwan on 3/1/24.
//

import Foundation
import CoreData


class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager ()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func delete(item: NSManagedObject) {
        viewContext.delete(item)
        save()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer (name: "GymnerModel")
        persistentContainer.loadPersistentStores{(description,error) in
            if let error = error {
                fatalError ("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
    
    /** Gets all the workout types from the WorkoutType Entity in Core Data*/
    func getWorkoutTypes() -> [WorkoutType]{
        let request: NSFetchRequest<WorkoutType> = WorkoutType.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
}
