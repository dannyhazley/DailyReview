//
//  MarkdownRenderingMethods.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct MarkdownRenderingService {
    let input: SavedReview
    let template: ReviewTemplate
    let subIds: [String: RenderNode]

    func createHeading(_ depth: Int, with heading: String) -> String {
        "\(String(repeating: "#", count: depth)) \(heading)\n"
    }

    func createSection(from sectionId: String) -> String {
        guard let node = subIds[sectionId] else { return MarkdownConstants.sectionRenderError }
        return renderNode(id: sectionId, node: node, depth: 0)
    }

    private func renderNode(id: String, node: RenderNode, depth: Int, groupValues: [String: [String]]? = nil) -> String {
        switch node {
        case .node(let type, let children):
            let currentLine: String

            switch type {
            case .heading:
                currentLine = renderHeading(id: id, depth: depth)
            case .text:
                currentLine = renderText(id: id, depth: depth, groupValues: groupValues)
            case .bullet:
                currentLine = renderBullet(id: id, depth: depth)
            case .task:
                currentLine = renderTask(id: id, depth: depth)
            case .group:
                return renderGroup(id: id, children: children, depth: depth)
            case .table:
                currentLine = renderTable(id: id, depth: depth)
            }

            let childText = children
                .map { child in
                    renderNode(id: child.id, node: child.node, depth: depth + 1)
                }
                .filter { !$0.isEmpty }
                .joined(separator: "\n")

            if childText.isEmpty {
                return currentLine
            } else if currentLine.isEmpty {
                return childText
            } else {
                return "\(currentLine)\n\(childText)"
            }
        }
    }

    private func renderHeading(id: String, depth: Int) -> String {
        guard let section = template.section(withId: id) else {
            return MarkdownConstants.headingRenderError
        }

        return createHeading(depth + 2, with: section.title)
    }

    private func renderText(id: String, depth: Int, groupValues: [String: [String]]? = nil) -> String {
        guard let field = template.field(withId: id) else {
            return MarkdownConstants.textRenderError
        }

        let indent = String(repeating: MarkdownConstants.markdownIndentChar, count: max(depth - 1, 0))
        let values = groupValues?[id] ?? input.textEntries[id] ?? []

        var returnedString = "\(indent)\(MarkdownConstants.markdownBulletPrefix)**\(field.label):**\n"

        if values.isEmpty {
            returnedString += "\(indent + MarkdownConstants.markdownIndentChar)\(MarkdownConstants.markdownBulletPrefix)\(MarkdownConstants.emptyInputPlaceholder)"
            return returnedString
        }

        returnedString += values
            .map { "\(indent + MarkdownConstants.markdownIndentChar)\(MarkdownConstants.markdownBulletPrefix)\($0)" }
            .joined(separator: "\n")

        return returnedString
    }

    private func renderBullet(id: String, depth: Int) -> String {
        let indent = String(repeating: MarkdownConstants.markdownIndentChar, count: max(depth - 1, 0))
        let values = input.textEntries[id] ?? []

        if values.isEmpty {
            return MarkdownConstants.emptyInputPlaceholder
        }

        return values
            .map { "\(indent)\(MarkdownConstants.markdownBulletPrefix)\($0)" }
            .joined(separator: "\n")
    }

    private func renderTask(id: String, depth: Int) -> String {
        let indent = String(repeating: MarkdownConstants.markdownIndentChar, count: max(depth - 1, 0))
        let values = input.textEntries[id] ?? []

        if values.isEmpty {
            return "\(indent)\(MarkdownConstants.taskFallback)"
        }

        return values
            .map { "\(indent)\(MarkdownConstants.markdownUncheckedTaskPrefix)\($0)" }
            .joined(separator: "\n")
    }

    private func renderGroup(id: String, children: [RenderNodeChild], depth: Int) -> String {
        guard let groupField = template.field(withId: id),
              let childFields = groupField.fields,
              let governingField = childFields.first(where: { $0.maxItems == 1 }) else {
            return MarkdownConstants.groupRenderError
        }

        let nestedFields = childFields.filter { $0.id != governingField.id }
        let groupEntryValues = input.groupEntries[id]?.first?.values ?? [:]

        let groupHeader = createHeading(depth + 2, with: groupField.label)
        let governingText = renderText(id: governingField.id, depth: depth, groupValues: groupEntryValues)

        let nestedText = nestedFields
            .map { renderNestedGroupChild(id: $0.id, depth: depth + 1, groupValues: groupEntryValues) }
            .joined(separator: "\n")

        return groupHeader + governingText + "\n" + nestedText
    }

    private func renderNestedGroupChild(id: String, depth: Int, groupValues: [String: [String]]) -> String {
        guard let field = template.field(withId: id) else {
            return MarkdownConstants.groupChildRenderError
        }

        let indent = String(repeating: MarkdownConstants.markdownIndentChar, count: max(depth - 1, 0))
        let values = groupValues[id] ?? []

        var returnedString = "\(indent)\(MarkdownConstants.markdownBulletPrefix)**\(field.label):**\n"

        if values.isEmpty {
            returnedString += "\(indent + MarkdownConstants.markdownIndentChar)\(MarkdownConstants.markdownBulletPrefix)\(MarkdownConstants.emptyInputPlaceholder)"
            return returnedString
        }

        returnedString += values
            .map { "\(indent + MarkdownConstants.markdownIndentChar)\(MarkdownConstants.markdownBulletPrefix)\($0)" }
            .joined(separator: "\n")

        return returnedString
    }

    private func renderTable(id: String, depth: Int) -> String {
        guard let field = template.field(withId: id),
              let columns = field.columns,
              let dataRows = input.tableEntries[id] else {
            return MarkdownConstants.tableRenderError
        }

        let columnLabels = columns.map(\.label)
        let indent = String(repeating: MarkdownConstants.markdownIndentChar, count: max(depth - 1, 0))

        let tableHeading = createRow(data: columnLabels, indent: indent, header: true)
        let tableBody = dataRows
            .map { createRow(data: $0.values, indent: indent) }
            .joined(separator: "\n")

        return tableHeading + "\n" + tableBody
    }

    private func createRow(data: [String], indent: String, header: Bool = false) -> String {
        let row = indent + "| " + data.joined(separator: MarkdownConstants.markdownTableCellSeparator) + " |"

        if header {
            return row + "\n\(indent)| " +
                String(repeating: MarkdownConstants.markdownTableDividerCell, count: data.count)
        }

        return row
    }
}
