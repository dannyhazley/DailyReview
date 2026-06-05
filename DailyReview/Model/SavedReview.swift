//
//  SavedReview.swift
//  DailyReview
//
//  Created by Danny Hazley on 05/06/2026.
//

import Foundation

struct SavedReview: Codable {
    let templateId: String
    let templateName: String
    let savedAt: Date
    let textEntries: [String: [String]]
    let tableEntries: [String: [TableEntry]]
    let groupEntries: [String: [GroupEntry]]
}
