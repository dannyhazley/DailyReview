//
//  ReviewInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct ReviewInputView: View {
    @State private var formState = ReviewFormState()
    
    let template: ReviewTemplate
    var body: some View {
        Text(template.name).font(Font.largeTitle)
        Divider().padding(.horizontal)
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(template.sections) { section in
                    SectionView(formState: $formState, section: section)
                }
                Button("SAVE"){
                    let savedReview = makeSavedReview(template: template, formState: formState)
//                    writeToJSON(savedReview: savedReview)
                    let response = FileIO.writeMarkdown(from: savedReview, using: template)
                    print(response)
                }.foregroundStyle(Color.red)
                    .font(Font.title2).bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }.padding()
        }
    }
    
    func makeSavedReview(template: ReviewTemplate, formState: ReviewFormState) -> SavedReview{
        SavedReview(
            templateId: template.id,
            templateName: template.name,
            savedAt: Date(),
            textEntries: formState.textEntries,
            tableEntries: formState.tableEntries,
            groupEntries: formState.groupEntries
        )
    }
    
    func writeToJSON(savedReview: SavedReview){
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            encoder.dateEncodingStrategy = .iso8601

            let data = try encoder.encode(savedReview)
            let jsonString = String(data: data, encoding: .utf8)

            print(jsonString ?? "Failed to build JSON string")
        } catch {
            print("Encoding failed: \(error)")
        }
    }
}

#Preview {
    ReviewInputView(template: try! TemplateLoader.loadTemplate(named: "dailyReview"))
}
