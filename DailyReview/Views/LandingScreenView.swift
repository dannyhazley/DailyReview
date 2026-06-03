//
//  LandingScreenView.swift
//  DailyReview
//
//  Created by Danny Hazley on 03/06/2026.
//

import SwiftUI

struct LandingScreenView: View {
    var body: some View {
        VStack{
            Text("What do you want to Review?")
                .font(Font.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.red)
 
            Spacer()
            
            ForEach (["Daily", "Weekly", "Monthly"], id: \.self) {reviewType in
                Button("\(reviewType) Review"){
                    
                }.font(Font.title)
                    .padding()
                    .foregroundStyle(Color.primary)
                    
            }
            
            Spacer()
        }.padding()
    }
}

#Preview {
    LandingScreenView()
}
