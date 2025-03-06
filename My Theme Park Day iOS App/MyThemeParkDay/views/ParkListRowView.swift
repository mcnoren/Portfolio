//
//  ParkListRowView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/19/24.
//

import SwiftUI

struct ParkListRowView: View {
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    @State var showTemplateView = false
    @Binding var parks: [String]
    let park: String
    
    var body: some View {
        ZStack {
            Button {
                showTemplateView = true
            } label: {
                Image(systemName: "info.circle")
            }
        }
        .sheet(isPresented: $showTemplateView, content: {
            TemplateView(park: park, parks: $parks)
        })
        
    }
}


