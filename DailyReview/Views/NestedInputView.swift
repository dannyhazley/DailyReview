//
//  NestedInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import SwiftUI

struct NestedInputView: View {
    let field: ReviewField
    
    private let mockEntries = [
            GroupEntry(values: [:]),
            GroupEntry(values: [:])
        ]

    var body: some View {
        VStack(alignment: .leading){
            Constants.lblText(field.label)
            
            if let subfields = field.fields, !subfields.isEmpty {
                VStack(alignment: .leading){
                    ForEach(mockEntries) { entry in
                        GroupEntryRow(entry: entry, subfields: subfields)
                    }
                }
                Button("Add \(field.label)"){
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
            }
            else {
                Constants.errorText("No subfields found")
            }
        }
        
        
    }
}

struct GroupEntryRow: View{
    let entry: GroupEntry
    let subfields: [ReviewField]
    
    private let isExpanded = false
    
    private var summaryText: String{
        subfields.first?.label ?? "Untitled Entry"
    }
    
    var body: some View{
        VStack(alignment: .leading){
            Button{
                
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
                    SubfieldListEditor(field: subfield)
                }
                Button("Add"){
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
            }.padding(.leading, 20)
        }
    }
}

struct SubfieldListEditor: View{
    let field: ReviewField
    
    private let mockValues = ["Example item"]
    
    var body: some View{
        VStack(alignment: .leading){
            Constants.lblText(field.label)
            
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    ForEach(Array(mockValues.enumerated()), id: \.offset) { idx, value in
                        Text("\(idx + 1): \(value)").frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }.frame(
                height: min(CGFloat(mockValues.count) * Constants.rowHeight, CGFloat(Constants.maxVisibleRows) * Constants.rowHeight))
            
            TextField(field.label, text: .constant("")).disabled(true)
            
        }
        
    }
}

struct GroupEntry: Identifiable{
    let id = UUID()
    var values: [String: [String]]
    
    static func empty(for subfields: [ReviewField]) -> GroupEntry {
        GroupEntry(
            values: Dictionary(uniqueKeysWithValues: subfields.map{($0.id, [])})
        )
    }
}

#Preview {
    NestedInputView(field: try! TemplateLoader.loadTemplate(named: "dailyReview").sections[2].fields.first!)
}
