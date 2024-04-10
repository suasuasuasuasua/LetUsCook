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
    @State private var selection: SidebarItem = .Gallery

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        }
        content: {}
        detail: {}
    }
}
