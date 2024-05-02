//
//  Day.swift
//  LetUsCook
//
//  Created by Justin Hoang on 5/2/24.
//

import Foundation
import SwiftData

@Model
final class CalendarDay: Identifiable {
    // MARK: - Attributes
    @Attribute(.unique)
    var id = UUID()

    var date: Date

    @Relationship(deleteRule: .cascade)
    var breakfast: Meal?
    @Relationship(deleteRule: .cascade)
    var lunch: Meal?
    @Relationship(deleteRule: .cascade)
    var dinner: Meal?

    // MARK: - Init
    init(date: Date) {
        self.date = date
    }
}
