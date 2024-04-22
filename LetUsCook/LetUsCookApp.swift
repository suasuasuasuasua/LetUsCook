//
//  LetUsCookApp.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/28/24.
//

import SwiftData
import SwiftUI

@main
struct LetUsCookApp: App {
    let dataModel: DataModel = DataModel()
    @State private var navigationContext = NavigationContext()

    var body: some Scene {
        // Change `WindowGroup` to `Window` so that we can't have multiple
        // windows of the same app open.
        WindowGroup {
            MainView()
                .modelContext(dataModel.modelContext)
                .environment(navigationContext)
        }
        .commands {
            SidebarCommands()
            // TODO: also do CMD-1,2,3,etc. to go through the sidebar items
        }

        Settings {
            SettingsView()
        }
    }
}
