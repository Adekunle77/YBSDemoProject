//
//  PhotosViewModelTests.swift
//  YBSDemoProjectTests
//
//  Created by Ade Adegoke on 11/09/2023.
//

import XCTest
import Combine
import Kingfisher
@testable import YBSDemoProject


class PhotosViewModelTests: XCTestCase {
    var viewModel: PhotosViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockPersistenceFactory: MockPersistenceFactory!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockPersistenceFactory = MockPersistenceFactory()
        viewModel = PhotosViewModel(repo: mockNetworkManager, persistence: mockPersistenceFactory)
    }

    override func tearDown() {
        mockNetworkManager = nil
        mockPersistenceFactory = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchingPhotosSuccess() {
        mockNetworkManager.shouldFail = false
        viewModel.getPhoto(of: "test search")
        XCTAssertFalse(viewModel.photos.isEmpty)
    }

    func testFetchingPhotosFailure() {
        mockNetworkManager.shouldFail = true
        viewModel.getPhoto(of: "example")
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.error)
    }
}
