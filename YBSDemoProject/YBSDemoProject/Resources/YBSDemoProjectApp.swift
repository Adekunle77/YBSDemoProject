//
//  YBSDemoProjectApp.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import SwiftUI

@main
struct YBSDemoProjectApp: App {
    
    init() {
        let container = DIContainer.shared
         container.register(type: Networkable.self, component: NetworkManager())
        container.register(type: PersistenceFactoryProtocol.self, component: PersistenceFactory())
    }
    
    var body: some Scene {
        WindowGroup {
     PhotosView()
        }
    }
}
