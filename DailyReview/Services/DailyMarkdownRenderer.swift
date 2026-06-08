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

    init(input: SavedReview, template: ReviewTemplate) {
        self.input = input
        self.template = template
    }

    private var fileName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.isoDateFormat
        return formatter.string(from: input.savedAt)
    }

    

    private var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = MarkdownConstants.dayFormat
        return formatter.string(from: input.savedAt)
    }

    private var renderingService: MarkdownRenderingService {
        MarkdownRenderingService(
            input: input,
            template: template,
            subIds: template.renderTree
        )
    }

    func render() -> String {
        """
        \(createFrontmatter())
        
        \(renderingService.createHeading(1, with: "\(fileName) \(day)"))
        
        \(renderingService.createHeading(2, with: MarkdownConstants.dailyCareerCaptureTitle))
        
        \(MarkdownConstants.dailyCareerCaptureIntro)
        
        \(renderingService.createSection(from: "snapshot"))
        
        \(renderingService.createSection(from: "work_done"))
        
        \(renderingService.createSection(from: "career_progression_evidence"))
        
        \(renderingService.createSection(from: "commercial_usefulness"))
        
        \(renderingService.createSection(from: "software_engineering_development"))
        
        \(renderingService.createSection(from: "communication_and_relationships"))
        
        \(renderingService.createSection(from: "personal_operating_context"))
        
        \(renderingService.createSection(from: "optional_detail"))
        
        \(renderingService.createSection(from: "tomorrow"))
        """
    }
    private func createFrontmatter() -> String {
        """
        \(MarkdownConstants.frontmatterFence)
        \(MarkdownConstants.frontmatterTypeKey): \(template.id)
        \(MarkdownConstants.frontmatterDateKey): \(fileName)
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
