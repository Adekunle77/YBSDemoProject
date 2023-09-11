//
//  Networkable.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import Foundation
import Combine

protocol Networkable {
    func fetchData<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError>
}
