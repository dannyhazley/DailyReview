//
//  ReviewInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct ReviewInputView: View {
    @State private var formState = ReviewFormState()
    @State private var showSaveMessage = false
    @State private var saveMessage = ""
    @State private var saveSuccessful = false
    @Environment(\.dismiss) private var dismiss

    
    let template: ReviewTemplate
    var body: some View {
        Text(template.name).font(Constants.Typography.reviewTitle)
        Divider().padding(.horizontal, Constants.Spacing.reviewDividerHorizontalPadding)
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(template.sections) { section in
                    SectionView(formState: $formState, section: section)
                }
                Button("SAVE") {
                    let savedReview = makeSavedReview(template: template, formState: formState)
                    let response = FileIO.writeMarkdown(from: savedReview, using: template)
                    
                    if response == FileIO.badWrite{
                        saveMessage = response
                    } else {
                        saveMessage = "File Saved successfully"
                        saveSuccessful = true
                    }
                    
                    showSaveMessage = true
                }.foregroundStyle(Constants.Colors.accent)
                    .font(Constants.Typography.primaryAction)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }.padding(Constants.Spacing.reviewContentPadding)
        }.alert("Review Saved", isPresented: $showSaveMessage) {
            if saveSuccessful {
                Button("Ok") {
                    dismiss()
                }
            }
            else{
                Button("Try Again", role: .cancel) { }
            }
            
        } message: {
            Text(saveMessage)
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
