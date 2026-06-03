//
//  TemplateLoader.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import Foundation

enum TemplateLoader {
    static func loadTemplate(named fileName: String) throws -> ReviewTemplate {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "TemplateLoader", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing template: \(fileName).json"
            ])
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(ReviewTemplate.self, from: data)
    }
}
