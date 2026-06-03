//
//  ReviewInputView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct ReviewInputView: View {
    var viewType: String
    var body: some View {
        Text("\(viewType) Review").font(Font.largeTitle)
    }
}

#Preview {
    ReviewInputView(viewType: "Daily")
}
