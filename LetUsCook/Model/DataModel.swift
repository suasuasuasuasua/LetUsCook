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

    var recipes: [Recipe] = []
    var sortRecipes: [KeyPathComparator<Recipe>] = [.init(\.name)]

    var sortInstructions: [KeyPathComparator<Instruction>] = [.init(\.index)]
    var sortIngredients: [KeyPathComparator<Ingredient>] = [.init(\.name)]

    init() {
        /// Define a model container to store the context for the data in the
        /// application
        let sharedModelContainer: ModelContainer = {
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

        container = sharedModelContainer
        modelContext = ModelContext(sharedModelContainer)
        
        fetchData()
    }

    func fetchData() {
        do {
            let sortOrder = [SortDescriptor<Recipe>(\.name)]
            let descriptor = FetchDescriptor<Recipe>(sortBy: sortOrder)
            
            recipes = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed in Datamodel fetchData()...")
        }
    }
}
