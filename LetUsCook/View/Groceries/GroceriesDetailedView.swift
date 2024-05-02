//
//  GroceriesDetailedView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 5/2/24.
//

import SwiftData
import SwiftUI

struct GroceriesDetailedView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query private var calendarDays: [CalendarDay]

    var startDate: Date? = Date.startDateOfWeek()

    // Wanted to use the predicate thingy but that wasn't working
    // Can't put this is the init for some reason ugh
    private var filteredDays: [CalendarDay] {
        calendarDays.filter { day in
            if let startDate {
                return startDate.isWithinOneWeek(otherDate: day.date)
            } else {
                return true
            }
        }
    }

    private var ingredients: [Ingredient] {
        var localIngredients: [Ingredient] = []

        for day in filteredDays {
            if let i = day.breakfast?.recipe?.ingredients {
                localIngredients.append(contentsOf: i)
            }
            if let i = day.lunch?.recipe?.ingredients {
                localIngredients.append(contentsOf: i)
            }
            if let i = day.dinner?.recipe?.ingredients {
                localIngredients.append(contentsOf: i)
            }
        }

        var uniqueIngredients: [Ingredient] = []
        for localIngredient in localIngredients {
            if !(uniqueIngredients.map(\.name)).contains(localIngredient.name) {
                uniqueIngredients.append(localIngredient)
            }
        }

        return uniqueIngredients
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredient List")
                .font(.title)
                .bold()
            Divider()

            ForEach(ingredients) { ingredient in
                Text("\(ingredient.name)")
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    GroceriesDetailedView()
}
