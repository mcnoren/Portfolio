//
//  EditEventView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/21/24.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var event: EventModel
    @Binding var events: [EventModel]
    @State var name: String = ""
    @State var type: String = ""
    @State var LL = false
    @State var singleRider = false
    let types = ["Attraction", "Food", "Entertainment", "Character Meet & Greet", "Other"]
    @FocusState var isEventNameFocused: Bool
    @State var replaceConfirmation: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .padding(10)
                    Spacer()
                    Button {
                        let index = events.firstIndex(where: { $0.name == name && name != event.name})
                        if index != nil {
                            replaceConfirmation = true
                        } else {
                            let new_event = EventModel(name: name, park: event.park, land: "", LL: LL, type: type, singleRider: singleRider)
                            let current_index = events.firstIndex(where: { $0.name == event.name })
                            events.remove(at: current_index!)
                            events.insert(new_event, at: current_index!)
                            print(events)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .padding(10)
                }
                HStack {
                    Text("Event Name")
                        .padding(10)
                        .font(.title3)
                    Spacer()
                    TextField("Enter Event Name",text: $name)
                        .padding()
                        .frame(width: 220, height: 40)
                        .background(Color.gray.opacity(0.2).cornerRadius(10))
                        .padding(10)
                        .submitLabel(.done)
                        .focused($isEventNameFocused)
                }
                HStack {
                    Text("Type")
                        .padding(10)
                        .font(.title3)
                    Spacer()
                    Picker("Choose an Event Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color.gray.opacity(0.2).cornerRadius(10))
                    .foregroundColor(Color.gray)
                    .padding(10)
                    .onTapGesture {
                        isEventNameFocused = false
                    }
                }
                .pickerStyle(.menu)
                
                Toggle(isOn: $LL, label: {
                    Text("Lightning Lane")
                        .font(.title3)
                })
                .padding(10)
                .toggleStyle(.switch)
                .onTapGesture {
                    isEventNameFocused = false
                }
                Toggle(isOn: $singleRider, label: {
                    Text("Single Rider")
                        .font(.title3)
                })
                .padding(10)
                .toggleStyle(.switch)
                .onTapGesture {
                    isEventNameFocused = false
                }
            }
        }
        .confirmationDialog("Delete", isPresented: $replaceConfirmation, titleVisibility: .hidden) {
                Button("Replace", role: .destructive) {
                    let new_event = EventModel(name: name, park: event.park, land: "", LL: LL, type: type, singleRider: singleRider)
                    let index = events.firstIndex(where: { $0.name == name})
                    events.remove(at: index!)
                    let current_index = events.firstIndex(where: { $0.name == event.name })
                    events.remove(at: current_index!)
                    events.insert(new_event, at: current_index!)
                    presentationMode.wrappedValue.dismiss()
                }
        } message: {
            Text("The event \(name) already Exists on this device. Are you sure you want to replace it?")
        }
    }
}
