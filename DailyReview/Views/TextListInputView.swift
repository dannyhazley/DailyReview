//
//  TextListInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import SwiftUI

struct TextListInputView: View {
    let field: ReviewField
    @Binding var entries: [String]
    @State private var draft = ""
    let prefix: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Constants.lblText(field.label)
            
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    ForEach(Array(entries.enumerated()), id: \.offset) { idx, entry in
                        let formattedEntry = entry.replacingOccurrences(of: "\n", with: "\n    ")
                        Text("\((prefix ?? "\(idx + 1): "))\(formattedEntry)")
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                
            }.frame(maxHeight: Constants.rowHeight * CGFloat(Constants.maxVisibleRows) * 2)
            
            if entries.count < (field.maxItems ?? Int.max) {
                TextField(field.label, text: $draft, axis: .vertical)
                
                Button("Add"){
                    let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    entries.append(trimmed)
                    draft = ""
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    
}

//#Preview {
//    TextListInputView()
//}
