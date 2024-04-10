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
        WindowGroup(id: "Recipes") {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
        }
        
        Settings {
            Text("Bruh")
        }
    }
}
