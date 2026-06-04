//
//  LandingScreenView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct LandingScreenView: View {
    let reviewTypes = [
        ("Daily", "dailyReview"),
        ("Weekly", "weeklyReview"),
        ("Monthly", "monthlyReview")
    ]

    var body: some View {
        VStack {
            Text("What do you want to Review?")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.red)

            Spacer()

            ForEach(reviewTypes, id: \.0) { reviewType in
                NavigationLink("Monthly Review") {
                    if let template = try? TemplateLoader.loadTemplate(named: "monthlyReview") {
                        ReviewInputView(template: template)
                    } else {
                        Text("Failed to load monthly review template.")
                            .foregroundStyle(.red)
                    }
                }
                .font(.title)
                .padding()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LandingScreenView()
}

enum ReviewType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}
