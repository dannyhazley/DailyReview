//
//  ReviewMarkdownRenderer.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct ReviewMarkdownRenderer {
    let input: SavedReview
    let template: ReviewTemplate
    let layout: ReviewMarkdownLayout

    private var renderingService: MarkdownRenderingService {
        MarkdownRenderingService(
            input: input,
            template: template,
            subIds: template.renderTree
        )
    }

    func render() -> String {
        ([createFrontmatter()] + layout.blocks.map(renderBlock))
            .map { $0.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }

    private func createFrontmatter() -> String {
        let fieldLines = layout.frontmatterFields.map { "\($0.0): \($0.1)" }
        let tagLines = [MarkdownConstants.frontmatterTagsKey + ":"]
            + layout.tags.map { MarkdownConstants.markdownBulletPrefix + $0 }

        return ([MarkdownConstants.frontmatterFence] + fieldLines + tagLines + [MarkdownConstants.frontmatterFence])
            .joined(separator: "\n")
    }

    private func renderBlock(_ block: ReviewMarkdownBlock) -> String {
        switch block {
        case .heading(let depth, let text):
            return renderingService.createHeading(depth, with: text)
        case .paragraph(let text):
            return text
        case .bulletedList(let items):
            return items.joined(separator: "\n")
        case .section(let sectionId):
            return renderingService.createSection(from: sectionId)
        }
    }
}
