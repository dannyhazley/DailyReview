//
//  FieldView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct FieldView: View {
    @Binding var formState: ReviewFormState
    
    let field: ReviewField
    
    var body: some View {
        switch field.type {
        case .text:
            text(for: field, with: textBinding)
        case .bullet:
            bullet(for: field, with: textBinding)
        case .task:
            task(for: field, with: textBinding)
        case .group:
            group(for: field, with: groupBinding)
        case .table:
            table(for: field, entries: tableBinding)
        }
    }
    
    
    func text(for field: ReviewField, with entries: Binding<[String]>) -> some View {
        TextListInputView(field: field, entries: entries, prefix: nil)
    }

    func bullet(for field: ReviewField, with entries: Binding<[String]>) -> some View {
        TextListInputView(field: field, entries: entries, prefix: "•  ")
    }

    func task(for field: ReviewField, with entries: Binding<[String]>) -> some View {
        TextListInputView(field: field, entries: entries, prefix: "○  ")
    }

    func group(for field: ReviewField, with entries: Binding<[GroupEntry]>) -> some View {
        VStack(alignment: .leading) {
            NestedInputView(entries: entries, field: field)
        }
    }

    func table(for field: ReviewField, entries: Binding<[TableEntry]>) -> some View {
        VStack(alignment: .leading) {
            TableView(entries: entries, field: field)
        }
    }
    
    var textBinding: Binding<[String]> {
        Binding(
            get: { formState.textEntries[field.id] ?? [] },
            set: {formState.textEntries[field.id] = $0}
        )
    }
    
    var tableBinding: Binding<[TableEntry]> {
        Binding(
            get: { formState.tableEntries[field.id] ?? [] },
            set: {formState.tableEntries[field.id] = $0}
        )
    }
    
    var groupBinding: Binding<[GroupEntry]> {
        Binding(
            get: { formState.groupEntries[field.id] ?? [] },
            set: {formState.groupEntries[field.id] = $0}
        )
    }
}

//#Preview {
//    FieldView(field: try! TemplateLoader.loadTemplate(named: "dailyReview").sections[2].fields.first!)
//}
