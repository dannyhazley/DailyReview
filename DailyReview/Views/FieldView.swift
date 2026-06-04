//
//  FieldView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct FieldView: View {
    
    
    let field: ReviewField
    
    var body: some View {
        switch field.type {
            case .text:
            text(for: field, with: [])
        case .bullet:
            bullet(for: field, with: [])
        case .task:
            task(for: field, with: [])
        case .group:
            group(for: field)
        case .table:
            table(for: field, with: [])
        }
    }
    
    
    func text (for field: ReviewField, with entries: [String]) -> some View {
        Constants.inputWithList(for: field, with: entries)
    }
    
    func bullet(for field: ReviewField, with entries: [String]) -> some View {
        Constants.inputWithList(for: field, with: entries, appending: "• ")
    }
    
    func task(for field: ReviewField, with entries: [String]) -> some View {
        Constants.inputWithList(for: field, with: entries, appending: "○ ")
    }
    
    func group(for field: ReviewField) -> some View {
        VStack(alignment: .leading){
            NestedInputView(field: field)
        }
    }
    
    func table(for field: ReviewField, with entries: [TableEntry]) -> some View {
        VStack(alignment: .leading){
            TableView(field: field, entries: entries)
        }
    }
}

#Preview {
    FieldView(field: try! TemplateLoader.loadTemplate(named: "dailyReview").sections[2].fields.first!)
}
