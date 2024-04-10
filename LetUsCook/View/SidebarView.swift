//
//  SidebarView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem

    var body: some View {
        // Navigation Basics (SUPER HELPFUL!! :))
        // https://www.youtube.com/watch?v=uE8RCE45Yxc
        List(selection: $selection) {
            // TODO: I like the sections, but hardcoding it like this feels ICKY
            Section("View") {
                ForEach([SidebarItem.Editor,
                         SidebarItem.Gallery])
                { item in
                    NavigationLink {
                        switch item {
                        case .Editor:
                            RecipeEditorView()
                        case .Gallery:
                            RecipeGalleryView()
                        default:
                            EmptyView()
                        }
                    } label: {
                        Label("\(item.rawValue)", systemImage: item.iconName)
                            .tag(item)
                    }
                }
            }
            Section("Plan") {
                ForEach([SidebarItem.Calendar,
                         SidebarItem.Groceries])
                { item in
                    NavigationLink {
                        switch item {
                        case .Editor:
                            RecipeEditorView()
                        case .Gallery:
                            RecipeGalleryView()
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
