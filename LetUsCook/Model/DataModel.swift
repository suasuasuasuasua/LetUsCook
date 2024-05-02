//
//  DataModel.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/14/24.
//

import Foundation
import SwiftData

@Observable
class DataModel {
    private var container: ModelContainer
    var modelContext: ModelContext

    init() {
        /// Define a model container to store the context for the data in the
        /// application
        let sharedModelContainer: ModelContainer = {
            let schema = Schema([
                Recipe.self,
                Category.self,
                Instruction.self,
                Ingredient.self,
                Meal.self,
                CalendarDay.self
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

        container = sharedModelContainer
        modelContext = ModelContext(sharedModelContainer)
    }
}
