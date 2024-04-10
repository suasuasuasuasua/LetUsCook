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
    /// Define a model container to store the context for the data in the
    /// application
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        // Change `WindowGroup` to `Window` so that we can't have multiple
        // windows of the same app open.
        Window("Let Us Cook", id: "main") {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
            // TODO: also do CMD-1,2,3,etc. to go through the sidebar items
        }

        Settings {
            // TODO: add the settings menu
            Text("Settings Menu")
                .padding()
                .frame(minWidth: 400, minHeight: 300)
        }
    }
}
