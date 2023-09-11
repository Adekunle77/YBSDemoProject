//
//  Notification+KeyboardHeight.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import UIKit

extension Notification {
    var keyboardHeight: CGFloat {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
