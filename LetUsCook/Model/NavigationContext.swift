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
    var selectedDate: Date? {
        didSet {
            print(selectedDate)
        }
    }
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
        selectedDate: Date? = nil,
        columnVisibility: NavigationSplitViewVisibility = .automatic
    ) {
        self.selectedSidebarItem = selectedSidebarItem
        self.selectedRecipe = selectedRecipe
        self.selectedDate = selectedDate
        self.columnVisibility = columnVisibility
    }
}
