//
//  EditTemplateView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/21/24.
//

import SwiftUI

struct EditTemplateView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    var park: String
    @State var parkName: String = ""
    @State var events: [EventModel] = []
    @State var importedEvents: [EventModel] = []
    @State var finalEvents: [EventModel] = []
    @State private var text = ""
    @State private var error: Error?
    @State var changed: Bool = false
    @State var firstChange: Bool = false
    @State var replaceConfirmation: Bool = false
    @State var deleteConfirmation: Bool = false
    @Binding var parks: [String]
    @FocusState var isParkNameFocused
    @State var showAddAttractionView: Bool = false
    @State var isImporting: Bool = false
    @State var incompatibleCSV: Bool = false
    @State var editing: Bool = false
    
    var body: some View {
        VStack {
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
            HStack {
                Text("Events")
                    .font(.title2)
                    .padding(.leading, 10)
                Spacer()
                Button {
                    withAnimation(.snappy(duration: !editing ? 0.2 : 0.6)) {
                        editing.toggle()
                    }
                } label: {
                    if !editing {
                        Text("Edit")
                    } else {
                        Text("Done")
                    }
                }
                .disabled(events.isEmpty)
                Button{
                    showAddAttractionView = true
                } label: {
                    Image(systemName: "plus")
                }
                .padding(.horizontal, 20)
            }
            ScrollView {
                ForEach(events, id: \.self) { event in
                    EventListRowView(newEvents: $events, editingEvents: events, event: event, editing: $editing)
                }
            }
            Button {
                isImporting = true
            } label: {
                Text("import park data")
            }
            .padding(.top, 20)
            Spacer()
            Button {
                deleteConfirmation = true
            } label: {
                HStack {
                    Text("Delete")
                        .padding(.horizontal, 20)
                        .foregroundStyle(.red)
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
            }
            .contentShape(Rectangle())
            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
            .background(Color(.systemGray6).cornerRadius(10))
            .padding()
        }
        .sheet(isPresented: $showAddAttractionView, content: {
            AddAttractionView(park: "", events: $events)
        })
        .sheet(isPresented: $isImporting, content: {
            csvExplanationView(incompatibleCSV: $incompatibleCSV, text: $text, importedEvents: $importedEvents, events: $events, error: $error, name: .constant(""))
        })
        .onAppear {
            parkName = park
            firstChange = true
            events = eventListViewModel.eventsForPark(parkName: park)
            if events.isEmpty {
                firstChange = false
            }
        }
        .onChange(of: events, {
            if !firstChange {
                changed = true
            } else {
                firstChange = false
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
        .navigationBarTitle("Edit Park")
        .navigationBarItems(
            trailing: Button(action: {
                finalEvents = []
                parkName = parkName.trimmingCharacters(in: .whitespaces)
                for event in events {
                    let finalEvent = EventModel(name: event.name, park: parkName, land: event.land, LL: event.LL, type: event.type, singleRider: event.singleRider, latitude: event.latitude, longitude: event.longitude)
                    finalEvents.append(finalEvent)
                }
                if park != parkName && EventListViewModel().parks.contains(parkName) {
                    replaceConfirmation = true
                } else {
                    eventListViewModel.deletePark(parkName: park)
                    eventListViewModel.addPark(parkName: parkName)
                    eventListViewModel.addEvents(newEvents: finalEvents)
                    parks = eventListViewModel.parks
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("Save")
            })
            .disabled(!(changed || park != parkName) || parkName.isEmpty)
            .padding(10)
        )
        
    }
    
    
}
