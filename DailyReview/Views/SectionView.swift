//
//  SectionView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct SectionView: View {
    let section: ReviewSection
    
    var body: some View {
        VStack(alignment: .leading){
            Text(section.title).font(Font.title)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
            
            if let description = section.description {
                Text(description).font(Font.default.italic())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
            }
            
            
            ForEach(section.fields){ field in
                FieldView(field: field).padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
            }
            Divider()
        }
    }
    
    
}

#Preview {
    SectionView(section: try! TemplateLoader.loadTemplate(named: "dailyReview").sections.first!)
}
