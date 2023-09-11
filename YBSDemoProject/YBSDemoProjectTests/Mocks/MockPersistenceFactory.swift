//
//  MockPersistenceFactory.swift
//  YBSDemoProjectTests
//
//  Created by Ade Adegoke on 11/09/2023.
//

import XCTest
@testable import YBSDemoProject

class MockPersistenceFactory: PersistenceFactoryProtocol {
    func createPersistence(for storage: Storage) throws -> Persistable {
        return MockPersistable()
    }
}
