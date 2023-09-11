//
//  RequestEndpoint.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import Foundation

enum RequestEndpoint {
    case photo(of: String)
}

extension RequestEndpoint: Endpoint {
    var path: String {
        switch self {
        case .photo:
            return AppConstants.flickrPathURL
        }
    }
    
    var baseURL: String {
        return AppConstants.flickrBaseURL
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .photo(let photo):
            return [
                URLQueryItem(name: "method", value: AppConstants.methodURL),
                URLQueryItem(name: "api_key", value: AppConstants.apiKey),
                URLQueryItem(name: "text", value: photo),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1")
            ]
        }
    }
}

