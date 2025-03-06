//
//  ParkTemplateListRowView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/20/24.
//

import SwiftUI

struct ParkTemplateListRowView: View {
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    let park: String
    @Binding var parks: [String]
    
    var body: some View {
        
        NavigationLink {
            EditTemplateView(park: park, parks: $parks)
        } label: {
            VStack {
                HStack {
                    Text(park)
                        .font(.title2)
                    Spacer()
                }
//                ForEach(eventListViewModel.getEventTypes(parkName: park), id: \.self) { type in
//                    Group {
//                        HStack {
//                            Text("\(countEventsForType(type: type)) \(type)s")
//                                .font(.subheadline)
//                            Spacer()
//                        }
//                    }
//                }
            }
        }
    }
    
    func countEventsForType(type: String) -> Int {
        var count = 0
        for event in eventListViewModel.eventsForPark(parkName: park) {
            if event.type == type {
                count += 1
            }
        }
        return count
    }
}
