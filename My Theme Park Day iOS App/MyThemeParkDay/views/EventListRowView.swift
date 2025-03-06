//
//  EventListRowView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/7/24.
//

import SwiftUI

struct EventListRowView: View {
    @Binding var newEvents: [EventModel]
    @State var editingEvents: [EventModel]
    let event: EventModel
    @State var deleteConfirmation: Bool = false
    @Binding var editing: Bool
    @State var showEditEventView: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                if editing {
                    Button {
                        deleteConfirmation = true
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red)
                            .padding(.leading, 10)
                    }
                }
                if(event.type == "Attraction") {
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .padding(.leading, 20)
                        .frame(width: 20)
                } else if event.type == "Food" {
                    Image(systemName: "fork.knife")
                        .font(.title3)
                        .padding(.leading, 20)
                        .frame(width: 20)
                } else if event.type == "Entertainment" {
                    Image(systemName: "wand.and.stars.inverse")
                        .font(.title3)
                        .padding(.leading, 20)
                        .frame(width: 20)
                } else if event.type == "Character Meet & Greet" {
                    Image(systemName: "figure.wave")
                        .font(.title3)
                        .padding(.leading, 20)
                        .frame(width: 20)
                }
                Text(event.name)
                    .padding(.leading, 15)
                Spacer()
                if !editing {
                    Button {
                        editingEvents = newEvents
                        showEditEventView = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 10)
        }
        .sheet(isPresented: $showEditEventView, content: {
            EditEventView(event: event, events: $editingEvents, name: event.name, type: event.type, LL: event.LL, singleRider: event.singleRider)
        })
        .onChange(of: editingEvents) {
            newEvents = editingEvents
        }
        .confirmationDialog("Delete", isPresented: $deleteConfirmation, titleVisibility: .hidden) {
                Button("Delete", role: .destructive) {
                    let index = newEvents.firstIndex(where: { $0.name == event.name })
                    if index != nil {
                        newEvents.remove(at: index!)
                    }
                    if newEvents.isEmpty {
                        editing = false
                    }
                }
        } message: {
            Text("Are you sure you want to delete \(event.name)?")
        }
    }
}
