//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selection: SidebarItem = SidebarItem.Gallery

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        }
        detail: {
            switch selection {
            case .Editor:
                EmptyView()
            case .Gallery:
                EmptyView()
            case .Calendar:
                EmptyView()
            case .Groceries:
                EmptyView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    do {
                        try modelContext.delete(model: Recipe.self)
                    } catch {
                        print("Failed to delete all the data")
                    }
                } label: {
                    Label("Clear all recipes", systemImage: "minus")
                        .help("Clear all recipes (DEBUG)")
                }
                // TODO: remove this in practice
                // CMD+D to delete all the entries
                .keyboardShortcut("d")
            }
        }
    }
}
