//
//  MarkdownDocumentContext.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct MarkdownDocumentContext {
    let savedAt: Date

    var isoDate: String {
        format(savedAt, with: MarkdownConstants.isoDateFormat)
    }

    var dayName: String {
        format(savedAt, with: MarkdownConstants.dayFormat)
    }

    var isoWeekId: String {
        let isoCalendar = Calendar(identifier: .iso8601)
        let week = isoCalendar.component(.weekOfYear, from: savedAt)
        let year = isoCalendar.component(.yearForWeekOfYear, from: savedAt)
        return "\(year)-W\(String(format: "%02d", week))"
    }

    var monthKey: String {
        format(savedAt, with: MarkdownConstants.monthFormat)
    }

    var monthName: String {
        format(savedAt, with: MarkdownConstants.monthFormatAsWords)
    }

    var weekBeginning: String {
        guard let monday = Calendar.current.nextDate(
            after: savedAt,
            matching: DateComponents(weekday: 2),
            matchingPolicy: .nextTime,
            direction: .backward
        ) else {
            return ""
        }

        return format(monday, with: MarkdownConstants.isoDateFormat)
    }

    var weekdays: [String] {
        guard let monday = Calendar.current.nextDate(
            after: savedAt,
            matching: DateComponents(weekday: 2),
            matchingPolicy: .nextTime,
            direction: .backward
        ) else {
            return []
        }

        let calendar = Calendar.current

        return (0...4)
            .compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
            .map { format($0, with: MarkdownConstants.isoDateFormat) }
    }

    var formattedWeekdays: [String] {
        weekdays.compactMap { weekday in
            guard let date = parse(weekday, with: MarkdownConstants.isoDateFormat) else {
                return nil
            }

            return "\(MarkdownConstants.markdownBulletPrefix)\(format(date, with: MarkdownConstants.dayFormat)) [[\(weekday)]]"
        }
    }

    var monthWeekBeginnings: [String] {
        let calendar = Calendar(identifier: .iso8601)

        guard let monthInterval = calendar.dateInterval(of: .month, for: savedAt),
              let firstMonday = calendar.nextDate(
                after: monthInterval.start.addingTimeInterval(-1),
                matching: DateComponents(weekday: 2),
                matchingPolicy: .nextTime
              ) else {
            return []
        }

        return stride(from: 0, through: 35, by: 7)
            .compactMap { offset in
                calendar.date(byAdding: .day, value: offset, to: firstMonday)
            }
            .prefix { $0 < monthInterval.end }
            .map { format($0, with: MarkdownConstants.isoDateFormat) }
    }

    var formattedMonthWeekBeginnings: [String] {
        monthWeekBeginnings.map {
            "\(MarkdownConstants.markdownBulletPrefix)[[WB \($0)]]"
        }
    }

    private func format(_ date: Date, with pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: date)
    }

    private func parse(_ value: String, with pattern: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.date(from: value)
    }
}
