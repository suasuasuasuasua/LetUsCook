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

    @Bindable var selectedDay: CalendarDay

    var body: some View {
        @Bindable var selectedDay = selectedDay

        Text(selectedDay.date.formatted(date: .abbreviated, time: .omitted))
            .bold()
            .font(.title)
        Text(selectedDay.date.dayOfWeek)
            .bold()
            .font(.title2)
        ScrollView {
            VStack(alignment: .leading) {
                // MARK: - Breakfast

                Text("Breakfast")
                    .underline()
                    .font(.title2)
                mealView(selectedDay: selectedDay, meal: $selectedDay.breakfast)
                Divider()

                // MARK: - Lunch

                Text("Lunch")
                    .underline()
                    .font(.title2)
                mealView(selectedDay: selectedDay, meal: $selectedDay.lunch)
                Divider()

                // MARK: - Dinner

                Text("Dinner")
                    .underline()
                    .font(.title2)
                mealView(selectedDay: selectedDay, meal: $selectedDay.dinner)
                Divider()
            }
        }
    }

    struct mealView: View {
        @Environment(NavigationContext.self) private var navigationContext
        @Environment(\.modelContext) private var modelContext
        @Query(sort: \Recipe.name) private var recipes: [Recipe]

        @Binding var meal: Meal?
        @State var selectedRecipe: Recipe?
        let selectedDay: CalendarDay

        init(selectedDay: CalendarDay, meal: Binding<Meal?>) {
            self.selectedDay = selectedDay
            _meal = meal
        }

        let iconSize: CGFloat = 50.0

        var body: some View {
            // MARK: - Choose the recipe

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
                    // Set the recipe as normal if the meal exists
                    if let meal {
                        meal.recipe = selectedRecipe
                    }
                    // Otherwise, we need to create the meal itself to store it
                    else {
                        let newMeal = Meal()
                        modelContext.insert(newMeal)
                        newMeal.recipe = selectedRecipe

                        meal = newMeal
                    }
                } else {
                    meal?.recipe = nil
                }
            }
            // Need this for the VERY first time we load in
            .onAppear {
                selectedRecipe = meal?.recipe
            }
            // Need this when we change between views
            .onChange(of: selectedDay) {
                selectedRecipe = meal?.recipe
            }

            // MARK: - Display the recipe

            if let meal, let recipe = meal.recipe {
                GalleryView.GalleryRow(recipe: recipe, iconSize: iconSize)
            }
        }
    }
}
