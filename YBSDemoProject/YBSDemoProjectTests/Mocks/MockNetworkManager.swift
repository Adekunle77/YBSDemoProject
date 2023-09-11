//
//  MockNetworkManager.swift
//  YBSDemoProjectTests
//
//  Created by Ade Adegoke on 11/09/2023.
//

import XCTest
import Combine
@testable import YBSDemoProject

class MockNetworkManager: Networkable {
    var shouldFail = false

    func fetchData<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        if shouldFail {
            return Fail(error: APIError.network(NSError(domain: "TestError", code: 0, userInfo: nil)))
                .eraseToAnyPublisher()
        } else {
            let mockData = Welcome(photos: Photos(page: 1, pages: 1, perpage: 1, total: 1, photo: [
                Photo(id: "53170241736", owner: "28011506@N04", secret: "dfccb4aff9", server: "65535", farm: 66, title: "Stagecoach Merseyside & South Lancashire 27261 SN65OCZ", ispublic: 1, isfriend: 0, isfamily: 0)
            ]), stat: "OK")
            return Just(mockData as! T)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
}
