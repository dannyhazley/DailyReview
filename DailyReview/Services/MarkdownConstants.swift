//
//  MarkdownConstants.swift
//  DailyReview
//
//  Created by Danny Hazley on 08/06/2026.
//

import Foundation

struct MarkdownConstants {
    static let isoDateFormat = "yyyy-MM-dd"
    static let dayFormat = "EEEE"
    static let monthFormatAsWords = "MMMM yyyy"
    static let monthFormat = "yyyy-MM"

    static let dailyCareerCaptureTitle = "Daily Career Capture"
    static let dailyCareerCaptureIntro = "This is the single daily tracking note. Capture work evidence, development, relationships, and the personal context that affects performance here."

    static let frontmatterFence = "---"
    static let frontmatterTypeKey = "type"
    static let frontmatterDateKey = "date"
    static let frontmatterWeekKey = "week"
    static let frontmatterMonthKey = "month"
    static let frontmatterWbKey = "week_beginning"
    static let frontmatterRoleKey = "role"
    static let frontmatterOrganisationKey = "organisation"
    static let frontmatterTagsKey = "tags"

    static let workEvidenceTag = "work/evidence"

    static let sectionRenderError = "_Couldn't render Section_"
    static let headingRenderError = "_Couldn't render heading_"
    static let textRenderError = "_Couldn't render text_"
    static let taskFallback = "- Nothing Planned"
    static let groupRenderError = "_Couldn't render Group_"
    static let groupChildRenderError = "_Couldn't render Group Child_"
    static let tableRenderError = "_Couldn't render Table_"
    static let emptyInputPlaceholder = "_Nothing noted from inputs_"

    static let markdownBulletPrefix = "- "
    static let markdownUncheckedTaskPrefix = "- [ ] "
    static let markdownTableCellSeparator = " | "
    static let markdownTableDividerCell = "--- |"
    static let markdownIndentChar = "    "
}
