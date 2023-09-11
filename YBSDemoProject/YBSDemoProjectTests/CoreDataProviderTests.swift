//
//  CoreDataProviderTests.swift
//  YBSDemoProjectTests
//
//  Created by Ade Adegoke on 07/09/2023.
//

import XCTest
import CoreData
@testable import YBSDemoProject

class CoreDataProviderTests: XCTestCase {
    
    var coreDataProvider: CoreDataProvider!

    override func setUpWithError() throws {
        coreDataProvider = CoreDataProvider(persistentContainer: TestCoreDataStack.shared.persistentContainer)
    }

    override func tearDownWithError() throws {
       coreDataProvider = nil
    }

    func testSaveAndGetFlickr() {
        let photo = Photo(id: "53170241736", owner: "28011506@N04", secret: "dfccb4aff9", server: "65535", farm: 66, title: "Stagecoach Merseyside & South Lancashire 27261 SN65OCZ", ispublic: 1, isfriend: 0, isfamily: 0)
        
        do {
            try coreDataProvider.save(object: photo)
            if let retrievedPhoto: Photo = try coreDataProvider.getObject(withID: photo) {
                XCTAssertEqual(retrievedPhoto.id, photo.id)
            }
        } catch {
            XCTFail("Error occurred: \(error.localizedDescription)")
        }
    }
        
    func testSaveAndDeleteFlickr() {
        let photo = Photo(id: "53170241736", owner: "28011506@N04", secret: "dfccb4aff9", server: "65535", farm: 66, title: "Stagecoach Merseyside & South Lancashire 27261 SN65OCZ", ispublic: 1, isfriend: 0, isfamily: 0)
        
        do {
            try coreDataProvider.save(object: photo)
            try coreDataProvider.delete(object: photo)
            
            let deletedPhoto: Photo? = try coreDataProvider.getObject(withID: photo)
            XCTAssertNil(deletedPhoto)
        } catch {
            XCTFail("Error occurred: \(error.localizedDescription)")
        }
    }

}
