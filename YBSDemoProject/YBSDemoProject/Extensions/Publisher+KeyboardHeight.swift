//
//  Publisher+KeyboardHeight.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import Combine
import UIKit

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        NotificationCenter.default.publisher(for: Publishers.keyboardHeightNotification)
            .map { ($0.userInfo?["height"] as? CGFloat) ?? 0 }
            .eraseToAnyPublisher()
    }
    
    static let keyboardHeightNotification = Notification.Name("KeyboardHeightNotification")
}

