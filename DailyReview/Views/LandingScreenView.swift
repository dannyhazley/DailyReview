//
//  LandingScreenView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct LandingScreenView: View {
    let reviewTypes = ReviewType.allCases

    var body: some View {
        VStack {
            Text("What do you want to Review?")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.red)

            Spacer()

            ForEach(reviewTypes, id: \.self) { reviewType in
                NavigationLink("\(reviewType.rawValue) Review") {
                    if let template = try? TemplateLoader.loadTemplate(named: reviewType.templateName) {
                        ReviewInputView(template: template)
                    } else {
                        Text("Failed to load \(reviewType.rawValue.lowercased()) review template.")
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
    NavigationStack {
        LandingScreenView()
    }
}

enum ReviewType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var templateName: String{
        switch self {
        case .daily:
            return "dailyReview"
        case .weekly:
            return "weeklyReview"
        case .monthly:
            return "monthlyReview"
        }
    }
}
