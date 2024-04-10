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
    @Binding var sidebarSelection: SidebarItem

    var body: some View {
        // Create a list of all the sidebar items, but group them by section
        List(selection: $sidebarSelection) {
            // Loop over all the groups
            ForEach(SidebarGroup.allCases) { group in
                // Create the section for the group
                Section(group.rawValue) {
                    // Loop over all the sidebar items in the group
                    ForEach(group.items) { item in
                        Label(item.rawValue, systemImage: item.iconName)
                            .tag(item)
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
