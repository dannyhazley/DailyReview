//
//  TableEntry.swift
//  DailyReview
//
//  Created by Danny Hazley on 05/06/2026.
//

import Foundation

struct TableEntry: Identifiable, Codable {
    let id: UUID
    let values: [String]
}
