//
//  AddAttractionView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/22/24.
//

import SwiftUI

struct AddAttractionView: View {
    @Environment(\.presentationMode) var presentationMode
    let park: String
    @Binding var events: [EventModel]
    @State var name: String = ""
    @State var type: String = "Select Type"
    @State var LL: Bool = false
    @State var singleRider: Bool = false
    @FocusState var isEventNameFocused
    let types = ["Select Type", "Attraction", "Food", "Entertainment", "Character Meet & Greet", "Other"]
    @State var replaceConfirmation: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Cancel")
                        })
                        .padding(10)
                        Spacer()
                        Button {
                            if events.contains(where: { $0.name == name }) {
                                replaceConfirmation = true
                            } else {
                                let event = EventModel(name: name, park: park, land: "", LL: LL, type: type, singleRider: singleRider)
                                events.append(event)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text("Add")
                        }
                        .padding(10)
                        .disabled(name.isEmpty  || type == "Select Type")
                    }
                    HStack {
                        Text("New Event")
                            .font(.largeTitle)
                            .bold()
                            .padding(.leading, 10)
                            .padding(.vertical, 5)
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
                    if type == "Attraction" {
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
            }
            .confirmationDialog("Delete", isPresented: $replaceConfirmation, titleVisibility: .hidden) {
                    Button("Replace", role: .destructive) {
                        let event = EventModel(name: name, park: park, land: "", LL: LL, type: type, singleRider: singleRider)
                        let index = events.firstIndex(where: { $0.name == name})
                        events.remove(at: index!)
                        events.append(event)
                        presentationMode.wrappedValue.dismiss()
                    }
            } message: {
                Text("The event \(name) already Exists on this device. Are you sure you want to replace it?")
            }
        }
    }
}
