//
//  RenderDailyMd.swift
//  DailyReview
//
//  Created by Danny Hazley on 05/06/2026.
//

import Foundation

struct RenderDailyMd {
    let input: SavedReview
    let template: ReviewTemplate
    private let indentChar = "\t"

    private var fileName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: input.savedAt)
    }

    private var weekId: String {
        let isoCalendar = Calendar(identifier: .iso8601)
        let week = isoCalendar.component(.weekOfYear, from: input.savedAt)
       let year = isoCalendar.component(.yearForWeekOfYear, from: input.savedAt)
       return "\(year)-W\(String(format: "%02d", week))"
    }
    
    private var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: input.savedAt)
    }
    
    private var subIds: [String: RenderNode] {
        template.renderTree
    }

    func render() -> String {
        """
        \(createHeader())
        """
    }
    
    private func createHeader() -> String{
        """
        ---
        type: daily-work-note
        date: \(fileName)
        week: \(weekId)
        role: \(PID.role)
        organisation: \(PID.organisaton)
        tags: 
        - #\(PID.organisaton.lowercased())/daily
        - #work/evidence
        ---
        
        \(createHeading(1, with: "\(fileName) \(day)")) 
        
        \(createHeading(2, with: "Daily Career Capture"))
        
        This is the single daily tracking note. Capture work evidence, development, relationships, and the personal context that affects performance here.
        
        \(createAllSections())
        """
    }

    private func createHeading(_ depth: Int, with heading: String) -> String{
        "\(String(repeating: "#", count: depth)) \(heading)\n"
    }

    private func createSection(from sectionId: String) -> String {
        guard let node = subIds[sectionId] else { return "" }
        return renderNode(id: sectionId, node: node, depth: 0)
    }

    private func createAllSections() -> String {
        template.sections
            .map { createSection(from: $0.id) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }

    private func renderNode(id: String, node: RenderNode, depth: Int, groupValues: [String: [String]]? = nil) -> String {
        switch node {
        case .node(let type, let children):
            let currentLine: String

            switch type {
            case .heading:
                currentLine = renderHeading(id: id, depth: depth)
            case .text:
                currentLine = renderText(id: id, depth: depth)
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
            return ""
        }

        return createHeading(depth + 2, with: section.title)
    }

    private func renderText(id: String, depth: Int, groupValues: [String: [String]]? = nil) -> String {
        guard let field = template.field(withId: id) else {
            return ""
        }

        let indent = String(repeating: indentChar, count: max(depth - 1, 0))
        let values = groupValues?[id] ?? input.textEntries[id] ?? []
        
        var returnedString = "\(indent)- *\(field.label):*\n"
        

        if values.isEmpty {
            returnedString += "\(indent + indentChar)- _Nothing noted from inputs_"
            return returnedString
        }

        returnedString += values
            .map { "\(indent + indentChar)- \($0)" }
            .joined(separator: "\n")
        
        return returnedString
    }

    private func renderBullet(id: String, depth: Int) -> String {
        let indent = String(repeating: indentChar, count: max(depth - 1, 0))
        let values = input.textEntries[id] ?? []

        if values.isEmpty {
            return "\(indent)-"
        }

        return values
            .map { "\(indent)- \($0)" }
            .joined(separator: "\n")
    }

    private func renderTask(id: String, depth: Int) -> String {
        let indent = String(repeating: indentChar, count: max(depth - 1, 0))
        let values = input.textEntries[id] ?? []

        if values.isEmpty {
            return "\(indent)- Nothing Planned"
        }

        return values
            .map { "\(indent)- [ ] \($0)" }
            .joined(separator: "\n")
    }

    private func renderGroup(id: String, children: [RenderNodeChild], depth: Int) -> String {
        guard let groupField = template.field(withId: id),
              let childFields = groupField.fields,
              let governingField = childFields.first(where: { $0.maxItems == 1 })
        else {return ""}
        
        let nestedFields = childFields.filter {$0.id != governingField.id}
        let groupEntryValues = input.groupEntries[id]?.first?.values ?? [:]
        
        let groupHeader = createHeading(depth + 2, with: groupField.label)
        let governingText = renderText(id: governingField.id, depth: depth+1, groupValues: groupEntryValues)
        
        let nestedText = nestedFields
            .map { renderNestedGroupChild(id: $0.id, depth: depth + 2, groupValues: groupEntryValues) }
            .joined(separator: "\n")
        
        return groupHeader + governingText + "\n" + nestedText
    }
    
    private func renderNestedGroupChild(id: String, depth: Int, groupValues: [String: [String]]) -> String {
        guard let field = template.field(withId: id) else {
            return ""
        }

        let indent = String(repeating: indentChar, count: max(depth - 1, 0))
        let values = groupValues[id] ?? []

        var returnedString = "\(indent)- *\(field.label):*\n"

        if values.isEmpty {
            returnedString += "\(indent + indentChar)- _Nothing noted from inputs_"
            return returnedString
        }

        returnedString += values
            .map { "\(indent + indentChar)- \($0)" }
            .joined(separator: "\n")

        return returnedString
    }

    private func renderTable(id: String, depth: Int) -> String {
        guard let field = template.field(withId: id),
              let columns = field.columns,
              let dataRows = input.tableEntries[id]
        else {return ""}
        
        let columnLabels = columns.map(\.label)
        
        let indent = String(repeating: indentChar, count: max(depth - 1, 0))
        
        let tableHeading = createRow(data: columnLabels, indent: indent, header: true)
                              
        let tableBody = dataRows
            .map { createRow(data: $0.values, indent: indent) }
            .joined(separator: "\n")
        
        return tableHeading + "\n" + tableBody
    }
    
    private func createRow(data: [String], indent: String, header: Bool = false) -> String {
        let row = indent + "| " + data.joined(separator:" | ") + " |"
        
        if header{
            return row + "\n\(indent)| " +
                String(repeating: "--- |", count: data.count)
        }
        
        return row
    }
}
