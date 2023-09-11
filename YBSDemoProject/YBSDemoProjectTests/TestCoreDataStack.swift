//
//  TestCoreDataStack.swift
//  YBSDemoProjectTests
//
//  Created by Ade Adegoke on 07/09/2023.
//

import XCTest
import CoreData
@testable import YBSDemoProject

class TestCoreDataStack {
    static let shared = TestCoreDataStack()
    
    private init() { }
    
    private lazy var privatePersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.coreDataModel)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var persistentContainer: NSPersistentContainer {
        return privatePersistentContainer
    }
}
