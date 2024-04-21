//
//  SidebarView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

// Navigation Basics - SUPER HELPFUL!! :)
// https://www.youtube.com/watch?v=uE8RCE45Yxc
struct SidebarView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigationContext = navigationContext

        // Create a list of all the sidebar items, but group them by section
        List(selection: $navigationContext.selectedSidebarItem) {
            ForEach(SidebarGroup.allCases) { group in
                // Create the section for the group
                Section(group.rawValue) {
                    SidebarSection(group: group)
                }
            }
        }
        .listStyle(.sidebar)
    }
    
    private struct SidebarSection: View {
        let group: SidebarGroup
        
        var body: some View {
            // Loop over all tche sidebar items in the group
            ForEach(group.items, id: \.self) { item in
                NavigationLink(value: item) {
                    item.label
                }
            }
        }
    }
}
