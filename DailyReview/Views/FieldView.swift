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
            text(for: field)
        case .bullet:
            bullet(for: field)
        case .task:
            task(for: field)
        case .group:
            group(for: field)
        case .table:
            tableInput(for: field, with: [])
        }
    }
    
    
    func text (for field: ReviewField) -> some View {
        Text("NOT CODED")
    }
    
    func bullet(for field: ReviewField) -> some View {
        Text("NOT CODED")
    }
    
    func task(for field: ReviewField) -> some View {
        Text("NOT CODED")
    }
    
    func group(for field: ReviewField) -> some View {
        Text("NOT CODED")
    }
    
    func tableInput(for field: ReviewField, with entries: [TableEntry]) -> some View {
        VStack(alignment: .leading) {
            constants.lblText(field.label)

            if let columns = field.columns {
                if entries.isEmpty {
                    constants.errorText("Please enter data into the fields below")
                } else {
                    table(columns, with: entries)
                }

                if let maxRows = field.maxRows, entries.count < maxRows {
                    columnInput(including: columns)
                }
            } else {
                constants.errorText("Table configuration error: no columns supplied.")
            }
        }
    }
    
    func table(_ columns: [ReviewTableColumn], with data: [TableEntry]) -> some View{
        return ScrollView(.horizontal){
            VStack(alignment: .leading){
                HStack{
                    ForEach(columns) { column in
                        Text(column.label)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .frame(width: constants.minColumnWidth, alignment: .leading)
                    }
                }
                Divider()
                
                ForEach(data){ row in
                    HStack{
                        ForEach(Array(columns.enumerated()), id: \.offset) { idx, col in
                            Text(row.values.indices.contains(idx) ? row.values[idx] : "")
                                .frame(width: constants.minColumnWidth, alignment: .leading)
                        }
                    }
                }
            }
        }
        
    }
    
    func columnInput(including columns: [ReviewTableColumn]) -> some View{
        VStack{
            ForEach(columns) { column in
                constants.input(for: column.label)
            }
            Button("Add to Table"){
                
            }
        }
    }
    
    
}

struct TableEntry: Identifiable {
    let id = UUID()
    let values: [String]
}

struct constants{
    @State static private var input: String = ""
    
    static let minColumnWidth: CGFloat = 150
    static let maxTableHeight: CGFloat = 300
    
    static func lblText (_ label: String)-> some View{
        Text(label).font(Font.subheadline).foregroundStyle(.tint)
    }
    
    static func errorText (_ label: String)-> some View{
        Text(label).font(Font.subheadline).foregroundStyle(.red).padding()
    }
    
    static func input (for label: String) -> some View{
        VStack(alignment: .leading){
            lblText(label)
            TextField(label, text: $input)
        }
    }
}

#Preview {
    FieldView(field: try! TemplateLoader.loadTemplate(named: "monthlyReview").sections.first!.fields.first!)
}
