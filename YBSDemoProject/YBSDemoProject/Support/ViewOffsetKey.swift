//
//  ViewOffsetKey.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//


import UIKit
import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

