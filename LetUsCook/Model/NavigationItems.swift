//
//  SidebarItems.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/8/24.
//

import Foundation

enum SidebarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case Editor
    case Gallery
    case Calendar
    case Groceries
    
    var iconName: String {
        switch self {
        case .Editor:
            "pencil.circle"
        case .Gallery:
            "book"
        case .Calendar:
            "calendar"
        case .Groceries:
            "list.bullet.clipboard"
        }
    }
}
