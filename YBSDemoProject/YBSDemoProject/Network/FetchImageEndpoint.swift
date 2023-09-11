//
//  FetchImageEndpoint.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 05/09/2023.
//

import Foundation
import SwiftUI

enum FetchImageEndpoint {
    case imageURL(_ url: String)
}

extension FetchImageEndpoint: Endpoint {
    var path: String {
        return ""
    }
    var baseURL: String {
        switch self {
        case .imageURL(let url):
            return url
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
}

