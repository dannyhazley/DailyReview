//
//  TableView.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import SwiftUI

struct TableView: View {
    @Binding var entries: [TableEntry]
    @State private var draftRow: [String: String] = [:]
    let field: ReviewField
    
    var body: some View {
        VStack(alignment: .leading) {
            Constants.lblText(field.label)

            if let columns = field.columns {
                if entries.isEmpty {
                    Constants.errorText("Please enter data into the fields below")
                } else {
                    table(columns, with: entries)
                }

                if entries.count < (field.maxRows ?? Int.max) {
                    columnInput(including: columns)
                }
            } else {
                Constants.errorText("Table configuration error: no columns supplied.")
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
                            .frame(width: Constants.minColumnWidth, alignment: .leading)
                    }
                }
                Divider()
                
                ForEach(data){ row in
                    HStack{
                        ForEach(Array(columns.enumerated()), id: \.offset) { idx, col in
                            Text(row.values.indices.contains(idx) ? row.values[idx] : "")
                                .frame(width: Constants.minColumnWidth, alignment: .leading)
                        }
                    }
                }
            }
        }
        
    }
    
    func columnInput(including columns: [ReviewTableColumn]) -> some View{
        VStack{
            ForEach(columns) { column in
                VStack(alignment: .leading){
                    Constants.lblText(column.label)
                    TextField(column.label, text: Binding(
                        get: { draftRow[column.id] ?? "" },
                        set: { draftRow[column.id] = $0 }
                    ), axis: .vertical)
                }
            }
            Button("Add to Table") {
                let rowValues = columns.map { column in
                    draftRow[column.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                }

                guard rowValues.contains(where: { !$0.isEmpty }) else { return }

                entries.append(TableEntry(id: UUID(), values: rowValues))
                draftRow = [:]
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}



//#Preview {
//    TableView(field: try! TemplateLoader.loadTemplate(named: "monthlyReview").sections[0].fields.first!, entries: [])
//}
