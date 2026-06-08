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

    init(input: SavedReview, template: ReviewTemplate) {
        self.input = input
        self.template = template
    }
    
    private var renderingService: MarkdownRenderingService {
        MarkdownRenderingService(
            input: input,
            template: template,
            subIds: template.renderTree
        )
    }

    private var monthWeekBeginnings: [String] {
        let calendar = Calendar(identifier: .iso8601)
        let referenceDate = input.savedAt

        guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate),
              let firstMonday = calendar.nextDate(
                after: monthInterval.start.addingTimeInterval(-1),
                matching: DateComponents(weekday: 2),
                matchingPolicy: .nextTime
              ) else {
            return []
        }

        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.isoDateFormat

        return stride(from: 0, through: 35, by: 7)
            .compactMap { offset in
                calendar.date(byAdding: .day, value: offset, to: firstMonday)
            }
            .prefix { $0 < monthInterval.end }
            .map { formatter.string(from: $0) }
    }

    private var formattedMonthWeekBeginnings: [String] {
        monthWeekBeginnings.map {
            "\(MarkdownConstants.markdownBulletPrefix)[[WB \($0)]]"
        }
    }

    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.monthFormatAsWords
        return formatter.string(from: input.savedAt)
    }
    
    private var monthAsDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.monthFormat
        return formatter.string(from: input.savedAt)
    }
    
    func render() -> String {
        """
        \(createFrontmatter())
        
        \(renderingService.createHeading(1, with: monthName))
        
        \(renderingService.createSection(from: "top_3_contributions"))
        
        \(renderingService.createSection(from: "best_evidence_i_was_useful"))
        
        \(renderingService.createSection(from: "feedback_and_recognition"))
        
        \(renderingService.createSection(from: "skills_improved"))
        
        \(renderingService.createSection(from: "biggest_lessons"))
        
        \(renderingService.createSection(from: "projects"))
        
        \(renderingService.createSection(from: "blockers_hr_people_themes"))
        
        \(renderingService.createSection(from: "progress_review_story"))
        
        \(renderingService.createSection(from: "next_month_focus"))
        
        \(renderingService.createHeading(2, with: "Weekly Notes"))
        \(formattedMonthWeekBeginnings.joined(separator: "\n"))
        """
    }
    private func createFrontmatter() -> String {
        """
        \(MarkdownConstants.frontmatterFence)
        \(MarkdownConstants.frontmatterTypeKey): \(template.id)
        \(MarkdownConstants.frontmatterMonthKey): \(monthAsDate)
        \(MarkdownConstants.frontmatterRoleKey): \(PID.role)
        \(MarkdownConstants.frontmatterOrganisationKey): \(PID.organisaton)
        \(MarkdownConstants.frontmatterTagsKey): 
        \(MarkdownConstants.markdownBulletPrefix)\(PID.organisaton.lowercased())/\(template.id.split(separator: "-")[0])
        \(MarkdownConstants.markdownBulletPrefix)\(MarkdownConstants.workEvidenceTag)
        \(MarkdownConstants.frontmatterFence)
        """
    }
}
