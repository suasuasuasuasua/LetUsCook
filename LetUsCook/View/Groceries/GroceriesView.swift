//
//  GroceryView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

/// View the groceries for the week (and any other week)
///
/// The user should be able to...
/// - See the categorized groceries (see how Apple does this in Reminders)
/// - Ask the user to create a folder in the Reminders App to populate the
///   groceries for the week
/// - Look at any week to view what
struct GroceriesView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query private var calendarDays: [CalendarDay]

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

    var startDate: Date? = Date.startDateOfWeek()
    var endDate: Date? = Date.startDateOfWeek()?
        .addingTimeInterval(Date.oneWeekInSeconds)

    var body: some View {
        if let startDate, let endDate {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(startDate.dateWithoutTime)")
                        .bold()
                        .font(.title)
                    Text("\(startDate.dayOfWeek) - \(endDate.dayOfWeek)")
                        .underline()
                        .font(.title2)
                    Divider()

                    ForEach(Date.getWeekDates(startDate: startDate),
                            id: \.self)
                    { date in
                        Text("\(date.dayOfWeek)")
                            .italic()

                        if let existingDay = (filteredDays.first { localDay in
                            localDay.date.isSame(date)
                        }),
                            let breakfast = existingDay.breakfast,
                            let lunch = existingDay.lunch,
                            let dinner = existingDay.dinner
                        {
                            if let breakfastName = breakfast.recipe?.name {
                                Text("Breakfast -- \(breakfastName)")
                            }
                            if let lunchName = lunch.recipe?.name {
                                Text("Lunch -- \(lunchName)")
                            }
                            if let dinnerName = dinner.recipe?.name {
                                Text("Dinner -- \(dinnerName)")
                            }
                        }
                        Spacer()
                        Divider()
                    }
                }
            }
            .padding()
        } else {
            ContentUnavailableView(
                "Could not calculate the date of this week",
                systemImage: "calendar"
            )
        }
    }

    func check(calendarDays: [CalendarDay], date: Date) -> CalendarDay? {
        calendarDays.first { day in
            day.date.isSame(date)
        }
    }
}
