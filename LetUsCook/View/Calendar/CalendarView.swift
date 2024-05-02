//
//  CalendarView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import MijickCalendarView
import SwiftData
import SwiftUI

/// The user should be able to view and assign meals to breakfast, lunch, and
/// dinner for each day.
///
/// The user should be able to...
/// - View an integrated calendar to see what they're eating next
/// - Give the option to subscribe to this calendar so that they can see it on
///   other devices their main calendar
///     - Mela does a thing where they ask "can we have full access to the
///       calendar so that we can populate your calendar with meals?"
struct CalendarView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query private var allCalendarDays: [CalendarDay]

    @State private var selectedDate: Date?

    var body: some View {
        createContent()
            // Change the navigation context's actual day
            // Insert a day if it doesn't exist
            .onChange(of: selectedDate) {
                @Bindable var navigationContext = navigationContext

                if let selectedDate {
                    // Find the existing day
                    if let existingDay = allCalendarDays.first(where: { day in
                        Calendar.current.isDate(
                            day.date,
                            inSameDayAs: selectedDate
                        )
                    }) {
                        navigationContext.selectedDay = existingDay
                    }
                    // Otherwise, create a new day and insert it into the model
                    else {
                        let newDay = CalendarDay(
                            date: selectedDate
                        )

                        modelContext.insert(newDay)
                        navigationContext.selectedDay = newDay
                    }

                } else {
                    navigationContext.selectedDay = nil
                }
            }
    }
}

// MARK: - Calendar

private extension WeekdayLabel {
    func createDefaultContent() -> some View {
        Text(getString(with: .veryShort))
            .foregroundColor(.accent)
            .font(.system(size: 14))
    }
}

// https://github.com/Mijick/CalendarView?tab=readme-ov-file
// Literally all copied just to get the functionality here
// Removed some fluff like the navigation bar, title, footer, etc.
private extension CalendarView {
    func createContent() -> some View {
        createCalendarView()
    }
}

private extension CalendarView {
    func createCalendarView() -> some View {
        return MCalendarView(
            selectedDate: $selectedDate,
            selectedRange: nil,
            configBuilder: configureCalendar
        )
        .padding(.horizontal, margins)
    }
}

private extension CalendarView {
    func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .daysHorizontalSpacing(9)
            .daysVerticalSpacing(19)
            .monthsBottomPadding(16)
            .monthsTopPadding(42)
            .monthLabel { ML.Center(month: $0) }
            .weekdaysView(MyWeekDaysView.init)
            .dayView(buildDayView)
    }
}

// MARK: - Weekdays Bar

private struct MyWeekDaysView: WeekdaysView {
    // Had to implement the protocols by myself here

    func createContent() -> AnyView {
        AnyView(erasing: createWeekdaysView())
    }

    private var mWeekdays: [MWeekday] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday,
    ]

    func createWeekdaysView() -> some View {
        HStack(spacing: 0) {
            ForEach(mWeekdays, id: \.self, content: createWeekdayItem)
        }
    }

    func createWeekdayItem(_ weekday: MWeekday) -> some View {
        createWeekdayLabel(weekday)
            .frame(maxWidth: .infinity)
    }

    func createWeekdayLabel(_ weekday: MWeekday) -> AnyWeekdayLabel {
        MyWeekDayLabel(weekday: weekday).erased()
    }
}

private struct MyWeekDayLabel: WeekdayLabel {
    var weekday: MWeekday

    func createContent() -> AnyView {
        Text(getString(with: .veryShort))
            .foregroundStyle(.accent)
            .font(.system(size: 14))
            .erased()
    }
}

// MARK: - Day View

private extension CalendarView {
    func buildDayView(
        _ date: Date,
        _ isCurrentMonth: Bool,
        selectedDate: Binding<Date?>?,
        range: Binding<MDateRange?>?
    ) -> DV.ColoredRectangle {
        return .init(
            date: date,
            color: getDateColor(date),
            isCurrentMonth: isCurrentMonth,
            selectedDate: selectedDate,
            selectedRange: nil
        )
    }
}

private extension CalendarView {
    func onContinueButtonTap() {}
    func getDateColor(_ date: Date) -> Color? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        let day = Calendar.current.dateComponents([.weekday], from: date)

        // Highlight sundays
        if day.weekday == 1 { return .greenAccent }

        return nil
    }
}

// MARK: - Modifiers

private let margins: CGFloat = 28
