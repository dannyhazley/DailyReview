//
//  Constants.swift
//  DailyReview
//
//  Created by Danny Hazley on 04/06/2026.
//

import SwiftUI

struct Constants{
    @State static private var input: String = ""
    
    static let minColumnWidth: CGFloat = 150
    static let maxTableHeight: CGFloat = 300
    static let rowHeight: CGFloat = 32
    static let maxVisibleRows = 5
    
    static func lblText (_ label: String)-> some View{
        Text(label).font(Font.subheadline).foregroundStyle(.tint)
    }
    
    static func errorText (_ label: String)-> some View{
        Text(label).font(Font.subheadline).foregroundStyle(.red).padding()
    }
    
    static func basicInput (for label: String) -> some View{
        VStack(alignment: .leading){
            lblText(label)
            TextField(label, text: $input)
        }
    }
    
    static func inputWithList(for field: ReviewField, with entries: [String], appending prefix: String? = nil) -> some View{
        VStack(alignment: .leading, spacing: 4){
            lblText(field.label)
            
            ScrollView(.vertical){
                ForEach(Array(entries.enumerated()), id: \.offset) { idx, entry in
                    Text("\((prefix ?? "\(idx + 1): "))\(entry)")
                }
            }.frame(height: min(CGFloat(entries.count) * rowHeight,
                                CGFloat(maxVisibleRows) * rowHeight))
            
            if entries.count < (field.maxItems ?? Int.max) {
                TextField(field.label, text: $input)
                
                Button("Add"){
                    
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
