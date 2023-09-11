//
//  DIContainer.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import Foundation

protocol DIContainerProtocol {
  func register<Service>(type: Service.Type, component: Any)
  func resolve<Service>(type: Service.Type) -> Service
}

final class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()
    var components: [String: Any] = [:]

    private init() {}

    func register<Service>(type: Service.Type, component: Any) {
        components["\(type)"] = component
    }

    func resolve<Service>(type: Service.Type) -> Service {
        components["\(type)"] as! Service
    }
}
