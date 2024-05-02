//
//  Date_days.swift
//  LetUsCook
//
//  Created by Justin Hoang on 5/2/24.
//

import Foundation

extension Date {
    // MARK: - Computed Properties

    static var oneDayInSeconds: Double {
        86400
    }

    // Really just 6 days
    static var oneWeekInSeconds: Double {
        518_400
    }

    var dateWithoutTime: String {
        return formatted(date: .abbreviated, time: .omitted)
    }

    // https://stackoverflow.com/a/35006174
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

    // MARK: - Functions

    // https://stackoverflow.com/a/35687720
    static func startDateOfWeek() -> Date? {
        // https://stackoverflow.com/a/69491976
        var calendar: Calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2

        return calendar.dateComponents(
            [.calendar, .yearForWeekOfYear, .weekOfYear],
            from: Date.now
        ).date
    }

    static func getWeekDates(startDate: Date) -> [Date] {
        var weekdates: [Date] = []
        for i in 0 ..< 7 {
            weekdates.append(
                startDate.addingTimeInterval(oneDayInSeconds * Double(i))
            )
        }

        return weekdates
    }

    func isWithinOneWeek(otherDate: Date) -> Bool {
        let oneWeekLater = addingTimeInterval(Date.oneWeekInSeconds)

        return (self ... oneWeekLater).contains(otherDate)
    }
}
