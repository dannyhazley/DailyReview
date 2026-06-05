//
//  ReviewFormState.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import Foundation

struct ReviewFormState: Codable{
    var textEntries: [String: [String]] = [:]
    var tableEntries: [String: [TableEntry]] = [:]
    var groupEntries: [String: [GroupEntry]] = [:]
}
