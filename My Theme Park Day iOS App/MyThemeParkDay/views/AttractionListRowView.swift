//
//  AttractionListRowView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/6/24.
//

import SwiftUI

struct AttractionListRowView: View {
    
    let attraction: EventModel
    
    var body: some View {
        ZStack {
            HStack {
                if(attraction.type == "Attraction") {
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .padding(.horizontal, 5)
                } else if attraction.type == "Food" {
                    Image(systemName: "fork.knife")
                        .font(.title3)
                        .padding(.horizontal, 5)
                } else if attraction.type == "Entertainment" {
                    Image(systemName: "wand.and.stars.inverse")
                        .font(.title3)
                        .padding(.horizontal, 5)
                }
                Text(attraction.name)
                Spacer()
                Text("")
                
            }
        }
    }
}
