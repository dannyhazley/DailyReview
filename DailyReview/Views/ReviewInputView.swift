//
//  ReviewInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct ReviewInputView: View {
    let template: ReviewTemplate
    var body: some View {
        Text(template.name).font(Font.largeTitle)
        Divider().padding(.horizontal)
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(template.sections) { section in
                    SectionView(section: section)
                }
                Button("SAVE"){
                    
                }.foregroundStyle(Color.red)
                    .font(Font.title2).bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }.padding()
        }
    }
    
    
}

#Preview {
    ReviewInputView(template: try! TemplateLoader.loadTemplate(named: "dailyReview"))
}
