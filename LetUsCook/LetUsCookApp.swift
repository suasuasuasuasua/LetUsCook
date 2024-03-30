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

    /// Define the navigation context for the whole application
    /// This keeps track of which menus and tabs are open and have been clicked
    /// on
    @State var navigationContext = NavigationContext()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(navigationContext)
        .modelContainer(sharedModelContainer)
        #if os(macOS)
            .commands {
                SidebarCommands()
            }
        #endif
    }
}
