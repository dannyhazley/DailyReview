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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FieldView(field: try! TemplateLoader.loadTemplate(named: "monthlyReview").sections.first!.fields.first!)
}
