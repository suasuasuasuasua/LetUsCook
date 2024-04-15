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
    @Environment(\.modelContext) private var modelContext
    @Binding var sidebarSelection: SidebarItem?

    var body: some View {
        // Create a list of all the sidebar items, but group them by section
        List(SidebarGroup.allCases, selection: $sidebarSelection) { group in
            // Create the section for the group
            Section(group.rawValue) {
                // Loop over all the sidebar items in the group
                ForEach(group.items) { item in
                    NavigationLink(value: item) {
                        item.label
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    SidebarView(sidebarSelection: .constant(.Gallery))
}
