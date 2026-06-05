//
//  NestedInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import SwiftUI

struct NestedInputView: View {
    @Binding var entries: [GroupEntry]
    let field: ReviewField
    @State private var expandedEntryID: GroupEntry.ID?
    @State private var draftEntry: GroupEntry?
    
    private var primarySubfield: ReviewField? {
        field.fields?.first(where: { $0.maxItems == 1 }) ?? field.fields?.first
    }

    var body: some View {
        VStack(alignment: .leading){
            Constants.lblText(field.label)
            
            if let subfields = field.fields, !subfields.isEmpty {
                VStack(alignment: .leading){
                    ForEach($entries) { $entry in
                        GroupEntryRow(entry: $entry, expandedEntryID: $expandedEntryID, subfields: subfields, primarySubfieldID: primarySubfield?.id)
                    }
                    
                    if let draftEntry {
                        DraftGroupEntryRow(entry: draftEntry, subfields: subfields, primarySubfieldID: primarySubfield?.id) { newEntry in
                            entries.append(newEntry)
                            self.draftEntry = nil
                            self.expandedEntryID = nil
                        } onDiscard: {
                            self.draftEntry = nil
                            self.expandedEntryID = nil
                        }
                    }
                }
                
                if draftEntry == nil {
                    Button("Add \(field.label)"){
                        let newEntry = GroupEntry.empty(for: subfields)
                        draftEntry = newEntry
                        expandedEntryID = newEntry.id
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            else {
                Constants.errorText("No subfields found")
            }
        }
        
        
    }
}

struct DraftGroupEntryRow: View {
    @State private var entry: GroupEntry
    let subfields: [ReviewField]
    let primarySubfieldID: String?
    let onCommit: (GroupEntry) -> Void
    let onDiscard: () -> Void

    init(
        entry: GroupEntry,
        subfields: [ReviewField],
        primarySubfieldID: String?,
        onCommit: @escaping (GroupEntry) -> Void,
        onDiscard: @escaping () -> Void
    ) {
        _entry = State(initialValue: entry)
        self.subfields = subfields
        self.primarySubfieldID = primarySubfieldID
        self.onCommit = onCommit
        self.onDiscard = onDiscard
    }

    private var summaryText: String {
        let firstValue = primarySubfieldID.flatMap { entry.values[$0]?.first }?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let firstValue, !firstValue.isEmpty {
            return firstValue
        }

        return "Untitled Entry"
    }

    private func finishDraft() {
        let firstValue = primarySubfieldID.flatMap { entry.values[$0]?.first }?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if firstValue.isEmpty {
            onDiscard()
        } else {
            onCommit(entry)
        }
    }

    var body: some View {
        VStack(alignment: .leading){
            Button{
                finishDraft()
            } label: {
                HStack {
                    Text(summaryText)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)

        VStack(alignment: .leading){
            ForEach(subfields) { subfield in
                SubfieldListEditor(
                    field: subfield,
                    values: Binding(
                        get: { entry.values[subfield.id] ?? [] },
                        set: { entry.values[subfield.id] = $0 }
                    )
                )
            }
        }.padding(.leading, 20)
    }
}

struct GroupEntryRow: View{
    @Binding var entry: GroupEntry
    @Binding var expandedEntryID: GroupEntry.ID?
    let subfields: [ReviewField]
    let primarySubfieldID: String?
    
    private var isExpanded: Bool{
        expandedEntryID == entry.id
    }
    
    private var summaryText: String{
        guard let primarySubfieldID else {
            return "Untitled Entry"
        }
        
        let firstValue = entry.values[primarySubfieldID]?.first?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let firstValue, !firstValue.isEmpty {
            return firstValue
        }
        
        return "Untitled Entry"
    }
    
    var body: some View{
        VStack(alignment: .leading){
            Button{
                expandedEntryID = isExpanded ? nil : entry.id
            } label: {
                HStack {
                    Text(summaryText)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right").foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        
        if isExpanded{
            VStack(alignment: .leading){
                ForEach(subfields) { subfield in
                    SubfieldListEditor(
                        field: subfield,
                        values: Binding(
                            get: { entry.values[subfield.id] ?? []},
                            set: { entry.values[subfield.id] = $0}
                        )
                    )
                }
            }.padding(.leading, 20)
        }
    }
}

struct SubfieldListEditor: View{
    let field: ReviewField
    @Binding var values: [String]
    @State private var draft = ""
    
    private var isPrimaryField: Bool{
        field.maxItems == 1
    }
    
    var body: some View{
        VStack(alignment: .leading){
            Constants.lblText(field.label)
            
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    ForEach(Array(values.enumerated()), id: \.offset) { idx, value in
                        Text("\(idx + 1): \(value)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }.frame(maxHeight: Constants.rowHeight * CGFloat(Constants.maxVisibleRows) * 2)
            
            if isPrimaryField {
                TextField(
                    field.label,
                    text: Binding(
                        get: { values.first ?? "" },
                        set: { newValue in
                            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            values = trimmed.isEmpty ? [] : [trimmed]
                        }
                    ),
                    axis: .vertical
                )
            } else if values.count < (field.maxItems ?? Int.max) {
                TextField(field.label, text: $draft, axis: .vertical)

                Button("Add") {
                    let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    values.append(trimmed)
                    draft = ""
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        
    }
}



//#Preview {
//    NestedInputView(field: try! TemplateLoader.loadTemplate(named: "dailyReview").sections[2].fields.first!)
//}
