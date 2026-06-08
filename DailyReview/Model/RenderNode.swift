//
//  RenderNode.swift
//  DailyReview
//
//  Created by Danny Hazley on 05/06/2026.
//

import Foundation

enum RenderNodeType: String {
    case heading
    case text
    case bullet
    case task
    case group
    case table
}

struct RenderNodeChild {
    let id: String
    let node: RenderNode
}

indirect enum RenderNode {
    case node(type: RenderNodeType, children: [RenderNodeChild])
}

extension ReviewTemplate {
    var renderTree: [String: RenderNode] {
        Dictionary(
            uniqueKeysWithValues: sections.map { section in
                (section.id, buildRenderNode(from: section))
            }
        )
    }

    func section(withId id: String) -> ReviewSection? {
        sections.first { $0.id == id }
    }

    func field(withId id: String) -> ReviewField? {
        for section in sections {
            if let field = field(withId: id, in: section.fields) {
                return field
            }
        }

        return nil
    }

    private func buildRenderNode(from section: ReviewSection) -> RenderNode {
        let children = section.fields.map { field in
            RenderNodeChild(id: field.id, node: buildRenderNode(from: field))
        }

        return .node(type: .heading, children: children)
    }

    private func buildRenderNode(from field: ReviewField) -> RenderNode {
        let children = (field.fields ?? []).map { childField in
            RenderNodeChild(id: childField.id, node: buildRenderNode(from: childField))
        }

        return .node(type: renderNodeType(for: field.type), children: children)
    }

    private func renderNodeType(for fieldType: FieldType) -> RenderNodeType {
        switch fieldType {
        case .text:
            return .text
        case .bullet:
            return .bullet
        case .task:
            return .task
        case .group:
            return .group
        case .table:
            return .table
        }
    }

    private func field(withId id: String, in fields: [ReviewField]) -> ReviewField? {
        for reviewField in fields {
            if reviewField.id == id {
                return reviewField
            }

            if let childFields = reviewField.fields,
               let nestedField = field(withId: id, in: childFields) {
                return nestedField
            }
        }

        return nil
    }
}
