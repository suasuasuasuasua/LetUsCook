//
//  SidebarGroups.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import Foundation

// https://www.youtube.com/watch?v=uE8RCE45Yxc
enum SidebarGroup: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case Create
    case Plan

    var items: [SidebarItem] {
        switch self {
        case .Create:
            [.Gallery]
        case .Plan:
            [
//                .Feed,
             .Calendar,
             .Groceries]
        }
    }
}
