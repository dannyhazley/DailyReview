//
//  Section.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import Foundation

enum FieldType: String, Codable {
    case text
    case bullet
    case task
    case group
    case table
}

struct ReviewTemplate: Codable, Identifiable {
    let id: String
    let name: String
    let sections: [ReviewSection]
}

struct ReviewSection: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let fields: [ReviewField]
}

struct ReviewField: Codable, Identifiable {
    let id: String
    let label: String
    let type: FieldType
    let maxItems: Int?
    let minRows: Int?
    let maxRows: Int?
    let value: String?
    let fields: [ReviewField]?
    let columns: [TableColumn]?
}

struct TableColumn: Codable, Identifiable {
    let id: String
    let label: String
    let type: FieldType
}

