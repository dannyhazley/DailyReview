//
//  MonthlyMarkdownRenderer.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct MonthlyMarkdownRenderer{
    let input: SavedReview
    let template: ReviewTemplate
    private var context: MarkdownDocumentContext { MarkdownDocumentContext(savedAt: input.savedAt) }
    
    func render() -> (markdown: String, filename: String) {
        (ReviewMarkdownRenderer(input: input, template: template, layout: layout).render(), "\(context.monthKey) Review")
    }

    private var layout: ReviewMarkdownLayout {
        ReviewMarkdownLayout(
            frontmatterFields: [
                (MarkdownConstants.frontmatterTypeKey, template.id),
                (MarkdownConstants.frontmatterMonthKey, context.monthKey),
                (MarkdownConstants.frontmatterRoleKey, PID.role),
                (MarkdownConstants.frontmatterOrganisationKey, PID.organisaton)
            ],
            tags: defaultTags,
            blocks: [
                .heading(1, context.monthName),
                .section("top_3_contributions"),
                .section("best_evidence_i_was_useful"),
                .section("feedback_and_recognition"),
                .section("skills_improved"),
                .section("biggest_lessons"),
                .section("projects"),
                .section("blockers_hr_people_themes"),
                .section("progress_review_story"),
                .section("next_month_focus"),
                .heading(2, "Weekly Notes"),
                .bulletedList(context.formattedMonthWeekBeginnings)
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
