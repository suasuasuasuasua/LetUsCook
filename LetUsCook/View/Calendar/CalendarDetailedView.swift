//
//  CalendarDetailedView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 5/2/24.
//

import SwiftData
import SwiftUI

struct CalendarDetailedView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query private var allCalendarDays: [CalendarDay]

    var selectedDay: CalendarDay?

    @State private var breakfast: Meal?
    @State private var lunch: Meal?
    @State private var dinner: Meal?

    init(day: CalendarDay?) {
        selectedDay = day

        breakfast = selectedDay?.breakfast
        lunch = selectedDay?.lunch
        dinner = selectedDay?.dinner
    }

    var body: some View {
        // MARK: - Valid Date

        if let selectedDay = navigationContext.selectedDay {
            @Bindable var selectedDay = selectedDay

            Text(selectedDay.date.formatted(date: .abbreviated, time: .omitted))
                .bold()
                .font(.title)
            VStack(alignment: .leading) {
                // MARK: - Breakfast

                Text("Breakfast")
                    .underline()
                    .font(.title2)
                mealView(meal: $breakfast)
                    .onChange(of: breakfast) {
                        selectedDay.breakfast = breakfast
                    }
                Divider()

                // MARK: - Lunch

                Text("Lunch")
                    .underline()
                    .font(.title2)
                mealView(meal: $lunch)
                    .onChange(of: lunch) {
                        selectedDay.lunch = lunch
                    }
                Divider()

                // MARK: - Dinner

                Text("Dinner")
                    .underline()
                    .font(.title2)
                mealView(meal: $dinner)
                    .onChange(of: dinner) {
                        selectedDay.dinner = dinner
                    }
                Divider()
            }
        }

        // MARK: - Invalid Date

        else {
            ContentUnavailableView("Select a date!", systemImage: "calendar")
        }
    }

    struct mealView: View {
        @Environment(NavigationContext.self) private var navigationContext
        @Environment(\.modelContext) private var modelContext
        @Query(sort: \Recipe.name) private var recipes: [Recipe]

        @Binding var meal: Meal?
        @State var selectedRecipe: Recipe? = nil

        let iconSize: CGFloat = 50.0

        var body: some View {
            // MARK: - Display the recipe

            if let meal, let recipe = meal.recipe {
                GalleryView.GalleryRow(recipe: recipe, iconSize: iconSize)
            }

            // MARK: - No Meal Chosen

            // Let the user choose a recipe
            // https://stackoverflow.com/a/73904851
            Picker("Choose a recipe", selection: $selectedRecipe) {
                Text("No option")
                    .tag(Recipe?(nil))
                ForEach(recipes) { recipe in
                    Text("\(recipe.name)")
                        .tag(Optional(recipe))
                }
            }
            .onChange(of: selectedRecipe) {
                if let selectedRecipe {
                    if let meal {
                        print("meal already exists")
                        meal.recipe = selectedRecipe
                    } else {
                        let newMeal = Meal()
                        modelContext.insert(newMeal)
                        newMeal.recipe = selectedRecipe

                        meal = newMeal
                        print("inserted new")
                    }
                }
            }
        }
    }
}
