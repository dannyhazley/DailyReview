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
        Text(label).font(Font.subheadline.weight(.semibold)).foregroundStyle(.secondary)
    }
    
    static func errorText (_ label: String)-> some View{
        Text(label).font(Font.subheadline).foregroundStyle(.red).padding()
    }
}
