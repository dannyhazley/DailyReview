//
//  GroupEntry.swift
//  DailyReview
//
//  Created by Danny Hazley on 05/06/2026.
//

import Foundation

struct GroupEntry: Identifiable, Codable{
    let id: UUID
    var values: [String: [String]]
    
    static func empty(for subfields: [ReviewField]) -> GroupEntry {
        GroupEntry(
            id: UUID(),
            values: Dictionary(uniqueKeysWithValues: subfields.map{($0.id, [])})
        )
    }
}
