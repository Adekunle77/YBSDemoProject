//
//  CoreDataStack.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 06/09/2023.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.coreDataModel)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
