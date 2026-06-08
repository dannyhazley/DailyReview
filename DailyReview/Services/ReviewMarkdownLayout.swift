//
//  ReviewMarkdownLayout.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

enum ReviewMarkdownBlock {
    case heading(Int, String)
    case paragraph(String)
    case bulletedList([String])
    case section(String)
}

struct ReviewMarkdownLayout {
    let frontmatterFields: [(String, String)]
    let tags: [String]
    let blocks: [ReviewMarkdownBlock]
}
