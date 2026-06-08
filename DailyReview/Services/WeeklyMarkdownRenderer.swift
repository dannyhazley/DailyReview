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
    
    private var weekdays: [String] {
        guard let lastMonday = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(weekday: 2),
            matchingPolicy: .nextTime,
            direction: .backward
        ) else {
            return []
        }

        let calendar = Calendar.current

        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.isoDateFormat

        return (0...4).compactMap { idx in
            calendar.date(byAdding: .day, value: idx, to: lastMonday)
        }.map {
            formatter.string(from: $0)
        }
    }
    
    private var formattedWeekdays: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.isoDateFormat
        
        var formattedWD: [String] = []
        
        for weekday in weekdays {
            formatter.dateFormat = MarkdownConstants.isoDateFormat
            if let date = formatter.date(from: weekday) {
                formatter.dateFormat = MarkdownConstants.dayFormat
                formattedWD.append("\(MarkdownConstants.markdownBulletPrefix)\(formatter.string(from: Date())) [[\(weekday)]]")
            }
        }
        
        return formattedWD
    }
    
    
    
    func render() -> String {
        """
        \(createFrontmatter())
        
        \(renderingService.createHeading(1, with: "Week Beginning \(weekdays[0])"))
        
        \(renderingService.createSection(from: "executive_summary"))
        
        \(renderingService.createHeading(2, with: "Daily Evidence"))
        \(formattedWeekdays.joined(separator: "\n"))
        
        \(renderingService.createSection(from: "major_contributions"))
        
        \(renderingService.createSection(from: "usefulness_as_an_employee"))
        
        \(renderingService.createSection(from: "software_engineering_evidence"))
        
        \(renderingService.createSection(from: "communications_and_decisions"))
        
        \(renderingService.createSection(from: "development_and_feedback"))
        
        \(renderingService.createSection(from: "hr_people_risk_log"))
        
        \(renderingService.createSection(from: "work_in_progress_ideas"))
        
        \(renderingService.createSection(from: "promotion_progress_review_evidence"))
        
        \(renderingService.createSection(from: "next_week"))
        """
    }
    private func createFrontmatter() -> String {
        """
        \(MarkdownConstants.frontmatterFence)
        \(MarkdownConstants.frontmatterTypeKey): \(template.id)
        \(MarkdownConstants.frontmatterWbKey): \(weekdays[0])
        \(MarkdownConstants.frontmatterWeekKey): \(renderingService.weekId.joined())
        \(MarkdownConstants.frontmatterRoleKey): \(PID.role)
        \(MarkdownConstants.frontmatterOrganisationKey): \(PID.organisaton)
        \(MarkdownConstants.frontmatterTagsKey): 
        \(MarkdownConstants.markdownBulletPrefix)\(PID.organisaton.lowercased())/\(template.id.split(separator: "-")[0])
        \(MarkdownConstants.markdownBulletPrefix)\(MarkdownConstants.workEvidenceTag)
        \(MarkdownConstants.frontmatterFence)
        """
    }
}

