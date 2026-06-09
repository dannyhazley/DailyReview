//
//  WeeklyMarkdownRenderer.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct WeeklyMarkdownRenderer {
    let input: SavedReview
    let template: ReviewTemplate
    private var context: MarkdownDocumentContext { MarkdownDocumentContext(savedAt: input.savedAt) }

    func render() -> (markdown: String, filename: String) {
        (ReviewMarkdownRenderer(input: input, template: template, layout: layout).render(), "WB \(context.weekBeginning)")
    }

    private var layout: ReviewMarkdownLayout {
        ReviewMarkdownLayout(
            frontmatterFields: [
                (MarkdownConstants.frontmatterTypeKey, template.id),
                (MarkdownConstants.frontmatterWbKey, context.weekBeginning),
                (MarkdownConstants.frontmatterWeekKey, context.isoWeekId),
                (MarkdownConstants.frontmatterRoleKey, PID.role),
                (MarkdownConstants.frontmatterOrganisationKey, PID.organisaton)
            ],
            tags: defaultTags,
            blocks: [
                .heading(1, "Week Beginning \(context.weekBeginning)"),
                .section("executive_summary"),
                .heading(2, "Daily Evidence"),
                .bulletedList(context.formattedWeekdays),
                .section("major_contributions"),
                .section("usefulness_as_an_employee"),
                .section("software_engineering_evidence"),
                .section("communications_and_decisions"),
                .section("development_and_feedback"),
                .section("hr_people_risk_log"),
                .section("work_in_progress_ideas"),
                .section("promotion_progress_review_evidence"),
                .section("next_week")
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
