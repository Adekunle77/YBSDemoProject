//
//  MockPersistable.swift
//  YBSDemoProjectTests
//
//  Created by Ade Adegoke on 11/09/2023.
//

import XCTest
@testable import YBSDemoProject

class MockPersistable: Persistable {
    var objects: [Any] = []

    func save<T>(object: T) throws {
        objects.append(object)
    }

    func getObject<T>(withID id: T) throws -> T? {
        if let index = objects.firstIndex(where: { $0 is T }) {
            return objects[index] as? T
        }
        return nil
    }

    func delete<T>(object: T) throws {
        if let index = objects.firstIndex(where: { $0 is T }) {
            objects.remove(at: index)
        }
    }

    func getllObject<T>() throws -> [T]? {
        return objects.compactMap { $0 as? T }
    }

    func deleteAllObjects() throws {
        objects.removeAll()
    }
}
