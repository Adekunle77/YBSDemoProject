//
//  Persistance.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 06/09/2023.
//

import Foundation

protocol Persistable {
    func save<T>(object: T) throws
    func getObject<T>(withID id: T) throws -> T?
    func delete<T>(object: T) throws
    func getllObject<T>() throws -> [T]?
    func deleteAllObjects() throws
}

enum Storage {
    case coreData
}

protocol PersistenceFactoryProtocol {
    func createPersistence(for storage: Storage) throws -> Persistable
}

class PersistenceFactory: PersistenceFactoryProtocol {
    func createPersistence(for storage: Storage) throws -> Persistable {
        switch storage {
        case .coreData:
            return CoreDataProvider(persistentContainer: CoreDataStack.shared.persistentContainer)
        }
    }
}
