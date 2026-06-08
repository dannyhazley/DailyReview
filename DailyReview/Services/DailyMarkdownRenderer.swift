//
//  DailyMarkdownRenderer.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct DailyMarkdownRenderer {
    let input: SavedReview
    let template: ReviewTemplate
    private var context: MarkdownDocumentContext { MarkdownDocumentContext(savedAt: input.savedAt) }

    func render() -> String {
        ReviewMarkdownRenderer(input: input, template: template, layout: layout).render()
    }

    private var layout: ReviewMarkdownLayout {
        ReviewMarkdownLayout(
            frontmatterFields: [
                (MarkdownConstants.frontmatterTypeKey, template.id),
                (MarkdownConstants.frontmatterDateKey, context.isoDate),
                (MarkdownConstants.frontmatterWeekKey, context.isoWeekId),
                (MarkdownConstants.frontmatterRoleKey, PID.role),
                (MarkdownConstants.frontmatterOrganisationKey, PID.organisaton)
            ],
            tags: defaultTags,
            blocks: [
                .heading(1, "\(context.isoDate) \(context.dayName)"),
                .heading(2, MarkdownConstants.dailyCareerCaptureTitle),
                .paragraph(MarkdownConstants.dailyCareerCaptureIntro),
                .section("snapshot"),
                .section("work_done"),
                .section("career_progression_evidence"),
                .section("commercial_usefulness"),
                .section("software_engineering_development"),
                .section("communication_and_relationships"),
                .section("personal_operating_context"),
                .section("optional_detail"),
                .section("tomorrow")
            ]
        )
    }

    private var defaultTags: [String] {
        [
            "\(PID.organisaton.lowercased())/\(template.id.split(separator: "-")[0])",
            MarkdownConstants.workEvidenceTag
        ]
    }
}
