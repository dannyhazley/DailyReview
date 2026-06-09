//
//  Constants.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import SwiftUI

enum Constants {
    enum Colors {
        static let accent = Color.red
        static let secondary = Color.secondary
        static let error = Color.red
    }

    enum Typography {
        static let landingTitle = Font.largeTitle.bold()
        static let reviewTitle = Font.largeTitle
        static let sectionTitle = Font.title
        static let sectionDescription = Font.default.italic()
        static let label = Font.subheadline.weight(.semibold)
        static let error = Font.subheadline
        static let navigationLink = Font.title
        static let primaryAction = Font.title2.bold()
        static let tableHeader = Font.subheadline
    }

    enum Spacing {
        static let pagePadding: CGFloat = 16
        static let reviewContentPadding: CGFloat = 16
        static let reviewDividerHorizontalPadding: CGFloat = 16
        static let listInputSpacing: CGFloat = 4
        static let sectionTitleBottomPadding: CGFloat = 1
        static let sectionDescriptionBottomPadding: CGFloat = 3
        static let fieldVerticalPadding: CGFloat = 1
        static let errorPadding: CGFloat = 16
        static let groupRowVerticalPadding: CGFloat = 8
        static let groupRowHorizontalPadding: CGFloat = 12
        static let nestedContentLeadingPadding: CGFloat = 20
    }

    enum Layout {
        static let minColumnWidth: CGFloat = 150
        static let rowHeight: CGFloat = 32
        static let maxVisibleRows = 5
        static let maxListHeightMultiplier: CGFloat = 2

        static var maxScrollableListHeight: CGFloat {
            rowHeight * CGFloat(maxVisibleRows) * maxListHeightMultiplier
        }
    }

    enum Symbols {
        static let expandedChevron = "chevron.down"
        static let collapsedChevron = "chevron.right"
    }

    enum Text {
        static let untitledEntry = "Untitled Entry"
        static let noSubfieldsFound = "No subfields found"
        static let emptyTablePrompt = "Please enter data into the fields below"
        static let missingTableColumns = "Table configuration error: no columns supplied."
    }

    static func labelText(_ label: String) -> some View {
        SwiftUI.Text(label)
            .font(Typography.label)
            .foregroundStyle(Colors.secondary)
    }

    static func errorText(_ label: String) -> some View {
        SwiftUI.Text(label)
            .font(Typography.error)
            .foregroundStyle(Colors.error)
            .padding(Spacing.errorPadding)
    }
}
