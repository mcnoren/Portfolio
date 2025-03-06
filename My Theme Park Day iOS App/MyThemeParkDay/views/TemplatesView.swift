//
//  TemplatesView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/20/24.
//

import SwiftUI

struct TemplatesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    @State var parks: [String] = []
    @State var showAddTemplateView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Button {
                        showAddTemplateView = true
                    } label: {
                        HStack {
                            Text("New Park")
                                .padding(.horizontal, 20)
                        }
                    }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    
                    Section {
                        ForEach(parks, id: \.self) { park in
                            ParkTemplateListRowView(park: park, parks: $parks)
                                .padding(.vertical, 10)
                        }
                        .onMove(perform: eventListViewModel.movePark)
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showAddTemplateView, content: {
            AddTemplateView(allParks: $parks)
        })
        .onAppear {
            parks = EventListViewModel().parks
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("Park Presets")
    }
}

