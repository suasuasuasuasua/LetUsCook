//
//  SidebarView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

// Navigation Basics (SUPER HELPFUL!! :))
// https://www.youtube.com/watch?v=uE8RCE45Yxc
struct SidebarView: View {
    @Binding var selection: SidebarItem

    var body: some View {
        // TODO: I like the idea of the sections, but hardcoding it like this
        // feels ICKY
        List(selection: $selection) {
            Section("Create") {
                let item = SidebarItem.Gallery
                NavigationLink {
                    // TODO: finish implementing the search filter
                    RecipeGalleryView()
                } label: {
                    Label("\(item.rawValue)", systemImage: item.iconName)
                        .tag(item)
                }
            }
            Section("Plan") {
                ForEach([SidebarItem.Calendar,
                         SidebarItem.Groceries])
                { item in
                    NavigationLink {
                        switch item {
                        case .Calendar:
                            CalendarView()
                        case .Groceries:
                            GroceriesView()
                        default:
                            EmptyView()
                        }
                    } label: {
                        Label("\(item.rawValue)", systemImage: item.iconName)
                            .tag(item)
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}
