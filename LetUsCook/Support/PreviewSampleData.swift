//
//  PreviewSampleData.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/31/24.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Recipe.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<Recipe>()).isEmpty {
            for recipe in SampleRecipes().contents {
                container.mainContext.insert(recipe)
            }
        }
        return container
    } catch {
        fatalError("Failed to create the sample container")
    }
}()
