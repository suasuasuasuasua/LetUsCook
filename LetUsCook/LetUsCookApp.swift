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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Ingredient.self,
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
        WindowGroup {
            NavigationSplitView {
                RecipeGalleryView()
                CalendarView()
            }
            detail: {
                Text("Select an item")
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
