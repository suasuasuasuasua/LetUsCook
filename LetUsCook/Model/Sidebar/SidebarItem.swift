//
//  SidebarItems.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/8/24.
//

import Foundation
import SwiftUI

enum SidebarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case Gallery
//    case Feed
    case Calendar
    case Groceries

    var iconName: String {
        switch self {
        case .Gallery:
            "book"
//        case .Feed:
//            "newspaper"
        case .Calendar:
            "calendar"
        case .Groceries:
            "list.bullet.clipboard"
        }
    }
    
    var label: Label<Text, Image> {
        Label(rawValue, systemImage: iconName)
    }
}
