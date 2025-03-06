//
//  EditScheduleView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/12/24.
//

import SwiftUI

struct EditScheduleView: View {
    
    @EnvironmentObject var dayListViewModel: DayListViewModel
    let day: DayModel
    @Binding var schedule: ScheduleModel
    @State var parks: [String] = []
    @State var lands: [String] = []
    let types = ["Attraction", "Food", "Entertainment", "Character Meet & Greet", "Other"]
    @State var LL: Bool = false
    @State var singleRider: Bool = false
    @State var name: String
    @State var park: String
    @State var land: String
    @State var type: String
    @State var postedWait: Int
    @State var startedWaiting: Date
    @State var startedEvent: Date = Date()
    @State var startedEventTemp: Date?
    @State var endedEvent: Date = Date()
    @State var endedEventTemp: Date?
    @Binding var editing: Bool
    @State var ride_broke_in_line: Bool
    @State var ride_broke_on_ride: Bool
    @State var latitude: Double?
    @State var longitude: Double?
    
    var body: some View {
            VStack {
                HStack {
                    Button {
                        editing = false
                    } label: {
                        Text("Cancel")
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    Spacer()
                    Button {
                        schedule = ScheduleModel(id: schedule.id, event: EventModel(name: name, park: park, land: land, type: type, latitude: latitude, longitude: longitude), notes: schedule.notes, LL: LL, type: type, startedWaiting: startedWaiting, startedEvent: startedEventTemp == nil ? nil: startedEvent, endedEvent: endedEventTemp == nil ? nil : endedEvent, postedWait: postedWait, photos: schedule.photos, singleRider: singleRider, ride_broke_in_line: ride_broke_in_line, ride_broke_on_ride: ride_broke_on_ride, aborted: schedule.aborted)
                        dayListViewModel.change_schedule(day_id: day.id, new_schedule: schedule)
                        editing = false
                    } label: {
                        Text("Done")
                            .padding(.horizontal, 20)
                    }
                    .disabled(LL && singleRider)
                    .padding(.top, 20)
                }
                
            ScrollView {
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
                }
                .pickerStyle(.menu)
                HStack {
                    Text("Park")
                        .padding(10)
                        .font(.title3)
                    Spacer()
                    Picker("Choose a Park", selection: $park) {
                        ForEach(parks, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color.gray.opacity(0.2).cornerRadius(10))
                    .foregroundColor(Color.gray)
                    .padding(10)
                }
                HStack {
                    Text("Land")
                        .padding(10)
                        .font(.title3)
                    Spacer()
                    Picker("Choose a Park", selection: $land) {
                        ForEach(lands, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color.gray.opacity(0.2).cornerRadius(10))
                    .foregroundColor(Color.gray)
                    .padding(10)
                }
                
                
                
                
                if type == "Attraction" {
                    Toggle(isOn: $LL, label: {
                        Text("Lightning Lane")
                            .font(.title3)
                    })
                    .padding(10)
                    .toggleStyle(.switch)
                    Toggle(isOn: $singleRider, label: {
                        Text("Single Rider")
                            .font(.title3)
                    })
                    .padding(10)
                    .toggleStyle(.switch)
                    HStack {
                        Text("Posted Wait")
                            .padding(10)
                            .font(.title3)
                        Spacer()
                        Picker("Choose a Posted Wait", selection: $postedWait) {
                            ForEach(5...300, id: \.self) {number in
                                if number % 5 == 0 {
                                    Text("\(number)").tag(number)
                                }
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: 220, maxHeight: 110)
                    }
                }
                if type != "Other" {
                    DatePicker(
                        "Started Waiting",
                        selection: $startedWaiting,
                        displayedComponents: [.hourAndMinute]
                    )
                    .padding(10)
                    .font(.title3)
                }
                if startedEventTemp != nil {
                    DatePicker(
                        "Started Event",
                        selection: $startedEvent,
                        displayedComponents: [.hourAndMinute]
                    )
                    .padding(10)
                    .font(.title3)
                }
                if endedEventTemp != nil {
                    DatePicker(
                        "Ended Event",
                        selection: $endedEvent,
                        displayedComponents: [.hourAndMinute]
                    )
                    .padding(10)
                    .font(.title3)
                }
                if type == "Attraction" {
                    Toggle(isOn: $ride_broke_in_line, label: {
                        Text("Ride broke in line")
                            .font(.title3)
                            .foregroundStyle(.red)
                    })
                    .padding(10)
                    .toggleStyle(.switch)
                    Toggle(isOn: $ride_broke_on_ride, label: {
                        Text("Ride broke on ride")
                            .font(.title3)
                            .foregroundStyle(.red)
                    })
                    .padding(10)
                    .toggleStyle(.switch)
                }
            }
            .onAppear(perform: {
                self.parks += dayListViewModel.get_day(day_id: day.id).parks
                self.parks += ["None"]
                self.lands += ["Other"]
                if self.startedEventTemp != nil {
                    self.startedEvent = self.startedEventTemp!
                }
                if self.endedEventTemp != nil {
                    self.endedEvent = self.endedEventTemp!
                }
            })
        }
    }
}
