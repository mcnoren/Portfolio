//
//  AddTemplateView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/17/24.
//

import SwiftUI

struct AddTemplateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    @State var isImporting: Bool = false
    @State private var text = ""
    @State private var error: Error?
    @State var incompatibleCSV: Bool = false
    @State var parkName: String = ""
    @FocusState var isParkNameFocused: Bool
    @Binding var allParks: [String]
    @State var replaceConfirmation: Bool = false
    @State var newEvents: [EventModel] = []
    @State var finalEvents: [EventModel] = []
    @State var showAddAttractionView: Bool = false
    @State var editing: Bool = false
    @State var imported: Bool = false
    
    var body: some View {
        ScrollView {
            HStack {
                Button("Cancel", action: {
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(10)
                Spacer()
                Button {
                    finalEvents = []
                    parkName = parkName.trimmingCharacters(in: .whitespaces)
                    for event in newEvents {
                        let finalEvent = EventModel(name: event.name, park: parkName, land: event.land, LL: event.LL, type: event.type, singleRider: event.singleRider, latitude: event.latitude, longitude: event.longitude)
                        finalEvents.append(finalEvent)
                    }
                    if allParks.contains(parkName) {
                        replaceConfirmation = true
                    } else {
                        eventListViewModel.addPark(parkName: parkName)
                        allParks.append(parkName)
                        eventListViewModel.addEvents(newEvents: finalEvents)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Add")
                }
                .disabled(parkName.isEmpty)
                .padding(10)
            }
            if incompatibleCSV == true {
                Text("*This file is not compatible")
                    .foregroundStyle(.red)
            }
            Text("New Park")
                .font(.largeTitle)
                .bold()
                .padding(.leading, 10)
                .padding(.vertical, 5)
            HStack {
                if !isParkNameFocused {
                    Text("Park Name")
                        .padding(10)
                        .font(.title3)
                    Spacer()
                }
                TextField("Enter Park Name",text: $parkName)
                    .padding()
                    .frame(width: isParkNameFocused ? UIScreen.main.bounds.width - 20 : 220, height: 40)
                    .background(Color.gray.opacity(0.2).cornerRadius(10))
                    .padding(10)
                    .submitLabel(.done)
                    .focused($isParkNameFocused)
            }
            .animation(.bouncy(duration: 0.4), value: isParkNameFocused)
//            HStack {
//                Text("Events")
//                    .font(.title2)
//                    .padding(.leading, 10)
//                Spacer()
//                Button {
//                    withAnimation(.snappy(duration: !editing ? 0.2 : 0.6)) {
//                        editing.toggle()
//                    }
//                } label: {
//                    if !editing {
//                        Text("Edit")
//                    } else {
//                        Text("Done")
//                    }
//                }
//                .padding(.horizontal, 20)
//                .disabled(newEvents.isEmpty)
//                Button{
//                    showAddAttractionView = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//                .padding(.horizontal, 20)
//            }
//            if newEvents.isEmpty {
//                Text("No Events")
//                    .padding()
//            }
            ForEach(newEvents, id: \.self) { event in
                AttractionListRowView(attraction: event)
            }
            Spacer()
            if !imported {
                Button {
                    isImporting = true
                } label: {
                    Text("import park data")
                }
                .padding(.top, 20)
            }
        }
        .sheet(isPresented: $showAddAttractionView, content: {
            AddAttractionView(park: "", events: $newEvents)
        })
        .sheet(isPresented: $isImporting, content: {
            csvExplanationView(incompatibleCSV: $incompatibleCSV, text: $text, importedEvents: $newEvents, events: $newEvents, error: $error, name: $parkName)
        })
        .confirmationDialog("Delete", isPresented: $replaceConfirmation, titleVisibility: .hidden) {
                Button("Replace", role: .destructive) {
                    eventListViewModel.addPark(parkName: parkName)
                    eventListViewModel.addEvents(newEvents: finalEvents)
                    presentationMode.wrappedValue.dismiss()
                }
        } message: {
            Text("The park \(parkName) already Exists on this device. Are you sure you want to replace it?")
        }
        .onChange(of: newEvents) {
            imported = true
        }
        
    }
}


