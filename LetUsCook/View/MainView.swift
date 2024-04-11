//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sidebarSelection: SidebarItem = .Gallery
    @State private var contentSelction = ""

    var body: some View {
        NavigationSplitView {
            // Make a selection from the sidebar
            SidebarView(sidebarSelection: $sidebarSelection)
        }
        content: {
            // Display the selection that you just made
            ContentView(sidebarSelection: $sidebarSelection)
        }
        detail: {}
    }
}

#Preview {
    MainView()
        .modelContainer(previewContainer)
}
