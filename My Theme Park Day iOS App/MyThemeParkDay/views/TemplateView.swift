//
//  TemplateView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/19/24.
//

import SwiftUI

struct TemplateView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    var park: String
    @State var parkName: String = ""
    @State var events: [EventModel] = []
    @State var finalEvents: [EventModel] = []
    @State var changed: Bool = false
    @State var firstChange: Bool = false
    @State var replaceConfirmation: Bool = false
    @State var deleteConfirmation: Bool = false
    @Binding var parks: [String]
    @FocusState var isParkNameFocused
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                    .padding(10)
                    Spacer()
                    //                Button(action: {
                    //                    finalEvents = []
                    //                    for event in events {
                    //                        let finalEvent = EventModel(name: event.name, park: parkName, land: event.land, LL: event.LL, type: event.type, singleRider: event.singleRider)
                    //                        finalEvents.append(finalEvent)
                    //                    }
                    //                    if park != parkName && EventListViewModel().parks.contains(parkName) {
                    //                        replaceConfirmation = true
                    //                    } else {
                    //                        eventListViewModel.deletePark(parkName: park)
                    //                        eventListViewModel.addPark(parkName: parkName)
                    //                        eventListViewModel.addEvents(newEvents: finalEvents)
                    //                        parks = eventListViewModel.parks
                    //                        presentationMode.wrappedValue.dismiss()
                    //                    }
                    //                }, label: {
                    //                    Text("Update")
                    //                })
                    //                .disabled(!(changed || park != parkName) || parkName.isEmpty)
                    //                .padding(10)
                }
                HStack {
                    //                Text("Park Name")
                    //                    .padding(10)
                    //                    .font(.title3)
                    //                Spacer()
                    Text(parkName)
                        .padding(10)
                        .font(.title)
                        .bold()
                    Spacer()
                    //                TextField("Enter Park Name",text: $parkName)
                    //                    .padding()
                    //                    .frame(width: 220, height: 40)
                    //                    .background(Color.gray.opacity(0.2).cornerRadius(10))
                    //                    .padding(10)
                    //                    .submitLabel(.done)
                    //                    .focused($isParkNameFocused)
                }
                HStack {
                    Text("Events")
                        .padding(15)
                        .font(.title2)
                    Spacer()
                }
                ForEach(events, id: \.self) { event in
                    AttractionListRowView(attraction: event)
                }
                if events.isEmpty {
                    Text("No Events")
                }
                Spacer()
                //            Button {
                //                deleteConfirmation = true
                //            } label: {
                //                HStack {
                //                    Text("Delete")
                //                        .padding(.horizontal, 20)
                //                        .foregroundStyle(.red)
                //                }
                //                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                //            }
                //            .contentShape(Rectangle())
                //            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                //            .background(Color(.systemGray6).cornerRadius(10))
                //            .padding()
            }
        }
        .onAppear {
            parkName = park
            events = eventListViewModel.eventsForPark(parkName: park)
            firstChange = true
        }
        .onChange(of: events, {
            if !firstChange {
                changed = true
            }
        })
        .onChange(of: isParkNameFocused, {
            if park != parkName {
                changed = true
            }
        })
        .confirmationDialog("Delete", isPresented: $replaceConfirmation, titleVisibility: .hidden) {
                Button("Replace", role: .destructive) {
                    eventListViewModel.deletePark(parkName: park)
                    eventListViewModel.addPark(parkName: parkName)
                    eventListViewModel.addEvents(newEvents: finalEvents)
                    parks = eventListViewModel.parks
                    presentationMode.wrappedValue.dismiss()
                }
        } message: {
            Text("The park \(parkName) already Exists on this device. Are you sure you want to replace it?")
        }
        .confirmationDialog("Delete", isPresented: $deleteConfirmation, titleVisibility: .hidden) {
                Button("Delete", role: .destructive) {
                    eventListViewModel.deletePark(parkName: park)
                    parks = eventListViewModel.parks
                    presentationMode.wrappedValue.dismiss()
                }
        } message: {
            Text("Are you sure you want to delete this park?")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
