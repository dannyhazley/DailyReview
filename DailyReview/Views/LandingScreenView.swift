//
//  LandingScreenView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct LandingScreenView: View {
    @State private var isChoosingFolder = false
    @State private var folderPickerReviewType: ReviewType?
    
    let reviewTypes = ReviewType.allCases

    var body: some View {
        VStack {
            Text("What do you want to Review?")
                .font(Constants.Typography.landingTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Colors.accent)

            Spacer()

            ForEach(reviewTypes, id: \.self) { reviewType in
                VStack{
                    NavigationLink("\(reviewType.rawValue) Review") {
                        if let template = try? TemplateLoader.loadTemplate(named: reviewType.templateName) {
                            ReviewInputView(template: template)
                        } else {
                            Text("Failed to load \(reviewType.rawValue.lowercased()) review template.")
                                .foregroundStyle(Constants.Colors.error)
                        }
                    }
                    .font(Constants.Typography.navigationLink)
                    
                    Button("Choose \(reviewType.rawValue) Folder"){
                        folderPickerReviewType = reviewType
                        isChoosingFolder = true
                    }
                }
                .padding(Constants.Spacing.pagePadding)
            }

            Spacer()
        }
        .padding(Constants.Spacing.pagePadding)
        .fileImporter(
            isPresented: $isChoosingFolder,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            guard let reviewType = folderPickerReviewType else {
                    print("No review type")
                    return
                }
            
            switch result {
            case.success(let urls):
                guard let folderURL = urls.first else {
                    print("No folder selected")
                    return
                }
                
                FileIO.saveFolder(folderURL, for: reviewType)
            case .failure(let error):
                print("Failed to choose folder: \(error)")
            }

            folderPickerReviewType = nil
        }
    }
    
    
}

#Preview {
    NavigationStack {
        LandingScreenView()
    }
}

enum ReviewType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var templateName: String{
        switch self {
        case .daily:
            return "dailyReview"
        case .weekly:
            return "weeklyReview"
        case .monthly:
            return "monthlyReview"
        }
    }
    
    var folderBookmarkKey: String {
        switch self {
        case .daily:
            return "dailyReviewOutputFolderBookmark"
        case .weekly:
            return "weeklyReviewOutputFolderBookmark"
        case .monthly:
            return "monthlyReviewOutputFolderBookmark"
        }
    }
}
