//
//  TimelineView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/5/24.
//

import SwiftUI

struct AttractionListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @Binding var selectedTab: Tabs
    @State var showAddScheduleView: Bool = false
    var day: DayModel
    @State var sort: String = "All"
    var sortList: [String] = ["All", "Attractions", "Food", "Entertainment", "Lightning Lane", "Single Rider"]
    @State var searchText: String = ""
    let types = ["Attraction", "Entertainment", "Food"]
    @State var events: [EventModel]
    @State var tab: String = "List"
    let tab_values = ["List", "Map"]
    @FocusState var barIsFocused: Bool
    @State var barIsFocused2: Bool = false
    
    var body: some View {
        var pickedEvent: EventModel = EventModel(name: "", park: "Disneyland", land: "Tommorowland", type: "Attraction")
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .padding(.leading, 10)
                            .bold()
                        Text("Back")
                    })
                    Spacer()
                }
                HStack {
                    Text("Add Event")
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                    Spacer()
                    Picker(selection: $sort, content: {
                        ForEach(sortList, id: \.self) {
                            Text($0)
                        }
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .padding(10)
                    })

                }
                if dayListViewModel.get_day(day_id: day.id).currentPark != "" && EventListViewModel().hasLocationData(parkName: dayListViewModel.get_day(day_id: day.id).currentPark) {
                    Picker(selection: $tab) {
                        ForEach(tab_values, id: \.self) { value in
                            Text(value)
                                .tag(value)
                        }
                    } label: {
                        Text("Screen Selector")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                SearchBarView(searchText: $searchText, barIsFocussed: $barIsFocused)
                if tab == "List" {
                    List {
                        Button {
                            pickedEvent = EventModel(name: "", park: dayListViewModel.get_day(day_id: day.id).currentPark, land: "", type: "")
                            showAddScheduleView = true
                        } label: {
                            HStack {
                                Text("Custom Event")
                                    .padding(.horizontal, 20)
                                //                            Spacer()
                            }
                        }
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity)
                        
                        ForEach(types, id: \.self) { type in
                            if !dayListViewModel.get_day(day_id: day.id).currentPark.isEmpty && (type == "Attraction" && ["All", "Attractions", "Lightning Lane", "Single Rider"].contains(sort) || type == "Food" && ["All", "Food"].contains(sort) || type == "Entertainment" && ["All", "Entertainment"].contains(sort)) {
                                Section("\(type)", content: {
                                    ForEach(events) { event in
                                        if event.type == type {
                                            if searchText.isEmpty || event.name.lowercased().contains(searchText.lowercased()) {
                                                if sort == "All" || sort == "Lightning Lane" && event.LL || sort == "Attractions" && event.type == "Attraction" || sort == "Food" && event.type == "Food" || sort == "Entertainment" && event.type == "Entertainment" || sort == "Single Rider" && event.singleRider{
                                                    if dayListViewModel.get_day(day_id: day.id).currentPark == event.park {
                                                        Button(action: {
                                                            pickedEvent = event
                                                            showAddScheduleView = true
                                                        }, label: {
                                                            AttractionListRowView(attraction: event)
                                                                .contentShape(Rectangle())
                                                                .frame(maxWidth: .infinity)
                                                        })
                                                        .buttonStyle(PlainButtonStyle())
                                                        
                                                    }
                                                }
                                                
                                                
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                    if dayListViewModel.get_day(day_id: day.id).currentPark == "" {
                        Text("Enter a park to see templates")
                            .font(.subheadline)
                            .foregroundStyle(Color(.gray))
                            .padding(.bottom, UIScreen.main.bounds.height / 2 - 40)
                            .padding(.top, 10)
                        Spacer()
                    }
                } else if tab == "Map" {
                    MapView(selectedTab: $selectedTab, day: day, sort: $sort, events: EventListViewModel().events, searchText: $searchText, barIsFocused: $barIsFocused2)
                }
            }
            .onChange(of: barIsFocused2, {
                if barIsFocused != barIsFocused2 {
                    barIsFocused = barIsFocused2
                }
            })
            .onChange(of: barIsFocused, {
                if barIsFocused != barIsFocused2 {
                    barIsFocused2 = barIsFocused
                }
            })
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                AppDelegate.orientationLock = .portrait
                if dayListViewModel.get_day(day_id: day.id).currentPark == "" || !EventListViewModel().hasLocationData(parkName: dayListViewModel.get_day(day_id: day.id).currentPark) {
                    tab = "List"
                }
            }
            .onDisappear {
                AppDelegate.orientationLock = .allButUpsideDown
            }
            .onChange(of: tab, {
                if tab == "List" && sort == "Attractions" {
                    sort = "All"
                }
            })
            .sheet(isPresented: $showAddScheduleView, content: {
                AddScheduleView(day_id: day.id, selectedTab: $selectedTab, name: pickedEvent.name, park: pickedEvent.park, land: pickedEvent.land, type: pickedEvent.type, latitude: pickedEvent.latitude, longitude: pickedEvent.longitude)
            })
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

