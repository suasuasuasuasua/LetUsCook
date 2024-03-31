//
//  Time.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import Foundation

/// Track the amout as a series of minutes and hours
struct Time {
    var minutes: Double
    var hours: Double

    /// Update the minutes on a `Time` object by some offset. 
    ///
    /// After offsetting, if the minute is greater than 60, increment the hours accordingly.
    /// Likewise, if the minutes is less than 0, decrement the hours accordingly
    func updateMinutes(_ minutes: Double) {
        d
    }

    func updateHours(_ hours: Double) {}

    func updateTime(withMinutes minutes: Double, withHours hours: Double) {}
}
