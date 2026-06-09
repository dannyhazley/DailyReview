//
//  SectionView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct SectionView: View {
    @Binding var formState: ReviewFormState
    
    let section: ReviewSection
    
    var body: some View {
        VStack(alignment: .leading){
            Text(section.title).font(Constants.Typography.sectionTitle)
                .padding(.bottom, Constants.Spacing.sectionTitleBottomPadding)
            
            if let description = section.description {
                Text(description).font(Constants.Typography.sectionDescription)
                    .padding(.bottom, Constants.Spacing.sectionDescriptionBottomPadding)
            }
            
            
            ForEach(section.fields){ field in
                FieldView(formState: $formState, field: field)
                    .padding(.vertical, Constants.Spacing.fieldVerticalPadding)
            }
            Divider()
        }
    }
    
    
}

//#Preview {
//    SectionView(formState: $ReviewFormState(), section: try! TemplateLoader.loadTemplate(named: "dailyReview").sections.first!)
//}
