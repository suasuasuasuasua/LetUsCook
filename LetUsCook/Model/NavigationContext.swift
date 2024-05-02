//
//  NavigationContext.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/19/24.
//

import Foundation
import SwiftUI

// https://developer.apple.com/documentation/swiftdata/deleting-persistent-data-from-your-app

@Observable
class NavigationContext {
    var selectedSidebarItem: SidebarItem?
    var selectedRecipe: Recipe?
    var selectedDay: CalendarDay?
    var columnVisibility: NavigationSplitViewVisibility

    var sidebarTitle = "Categories"

    var contentListTitle: String {
        if let selectedSidebarItem {
            selectedSidebarItem.rawValue
        } else {
            ""
        }
    }

    init(
        selectedSidebarItem: SidebarItem? = .Calendar,
        selectedRecipe: Recipe? = nil,
        selectedDate: CalendarDay? = nil,
        columnVisibility: NavigationSplitViewVisibility = .automatic
    ) {
        self.selectedSidebarItem = selectedSidebarItem
        self.selectedRecipe = selectedRecipe
        self.selectedDay = selectedDate
        self.columnVisibility = columnVisibility
    }
}
