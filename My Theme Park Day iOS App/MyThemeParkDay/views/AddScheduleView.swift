//
//  AddScheduleView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/9/24.
//

import SwiftUI
import MapKit

struct AddScheduleView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    let day_id: String
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var selectedTab: Tabs
    @State var startedWaiting: Date = Date()
    @State var startedEvent: Date = Date()
    @State var LL: Bool = false
    @State var singleRider: Bool = false
    @State var name: String = ""
    @State var park: String = "Select Park"
    @State var land: String = "Select Land"
    @State var type: String = "Select Type"
    @State var postedWait: Int = 5
    @State var postedWaitString: String  = "0"
    @State var latitude: Double? = nil
    @State var longitude: Double? = nil
    @State var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.809135, longitude: -117.918966), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
    @State var camera: MapCameraPosition = .automatic
    @State var location = CLLocationCoordinate2D(latitude: 33.809135, longitude: -117.918966)
    let calendar = Calendar.current
    @State var parks = ["Select Park"]
    @State var lands = ["Select Land"]
    let types = ["Select Type", "Attraction", "Food", "Entertainment", "Character Meet & Greet", "Other"]
    @State var showError: Bool = false
    @FocusState var isEventNameFocused: Bool
    
    var body: some View {
        
        ScrollView {
            ZStack {
                VStack {
                    HStack {
                        Button("Cancel", action: {
                            presentationMode.wrappedValue.dismiss()
                        })
                        .padding(10)
                        Spacer()
                        Button("Add", action: saveButtonPressed)
                            .padding(10)
                            .disabled(name.isEmpty || park.isEmpty || park == "Select Park"  || !can_add_another_schedule() || type == "Select Type" || LL && singleRider)
                    }
                    if !can_add_another_schedule() && showError {
                        Text("*An event is still in progress")
                            .foregroundStyle(.red)
                            .padding(.bottom, 5)
                        Button {
                            selectedTab = .home
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Show me")
                        }
                    }
                    Text("Add Event")
                        .font(.title)
                        .padding(.top)
                        .onReceive(timer) { _ in
                            showError = true
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
                    if type != "Select Type" {
//                        HStack {
//                            Text("Park")
//                                .padding(10)
//                                .font(.title3)
//                            Spacer()
//                            Picker("Choose a Park", selection: $park) {
//                                ForEach(parks, id: \.self) {
//                                    Text($0)
//                                }
//                            }
//                            .padding()
//                            .frame(width: 220, height: 40)
//                            .background(Color.gray.opacity(0.2).cornerRadius(10))
//                            .foregroundColor(Color.gray)
//                            .padding(10)
//                            .onTapGesture {
//                                isEventNameFocused = false
//                            }
//                        }
                        if !dayListViewModel.get_day(day_id: day_id).scheduleList.isEmpty && dayListViewModel.get_day(day_id: day_id).scheduleList[dayListViewModel.get_day(day_id: day_id).scheduleList.count - 1].endedEvent != nil {
                            if type != "Other" {
                                DatePicker(
                                    "Started Waiting",
                                    selection: $startedWaiting,
                                    displayedComponents: [.hourAndMinute]
                                )
                                .padding(10)
                                .font(.title3)
                                .onTapGesture {
                                    isEventNameFocused = false
                                }
                            } else {
                                DatePicker(
                                    "Started Event",
                                    selection: $startedEvent,
                                    in: dayListViewModel.get_day(day_id: day_id).scheduleList[dayListViewModel.get_day(day_id: day_id).scheduleList.count - 1].endedEvent!...Date(),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .padding(10)
                                .font(.title3)
                                .onTapGesture {
                                    isEventNameFocused = false
                                }
                            }
                        }
                        if (type == "Attraction" || type == "Entertainment") && park != "None" && park != "Select Park"{
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
                                .onTapGesture {
                                    isEventNameFocused = false
                                }
                            }
                        }
                    }
                    if longitude != nil && latitude != nil {
                        Map(position: $camera) {
                            Annotation("", coordinate: location) {
                                MapAnnotationView(mapRegion: $mapRegion, event: EventModel(name: name, park: park, land: "", type: type), selectedEvent: .constant(nil))
                            }
                        }
                        .padding(20)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 10.0)))
                        .mapStyle(.imagery)
                        .disabled(true)
                        .frame(height: 200)
                    }
                }
            }
        }
        .onAppear(perform: {
            startedWaiting = Date()
            if park.isEmpty {
                park = "Select Park"
            }
            if land.isEmpty {
                land = "Select Land"
            }
            if type.isEmpty {
                type = "Select Type"
            }
            parks = []
            for park in dayListViewModel.get_day(day_id: day_id).parks {
                if dayListViewModel.get_day(day_id: day_id).currentPark == park {
                    self.parks += [park]
                }
            }
            self.parks += ["None"]
            self.lands += ["Other"]
            if latitude == nil && longitude == nil {
                let l = CLLocationManager().location
                if l != nil {
                    latitude = l?.coordinate.latitude
                    longitude = l?.coordinate.longitude
                }
            }
            if latitude != nil && longitude != nil {
                mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
                location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                camera = .region(mapRegion)
            }
        })
    }
    func saveButtonPressed() {
        if type != "Other" {
            dayListViewModel.append_scheduleList(day_id: day_id, schedule: ScheduleModel(event: EventModel(name: name, park: park, land: land, type: type, latitude: latitude, longitude: longitude), LL: LL, type: type, startedWaiting: startedWaiting, postedWait: postedWait, singleRider: singleRider))
        } else {
            dayListViewModel.append_scheduleList(day_id: day_id, schedule: ScheduleModel(event: EventModel(name: name, park: park, land: land, type: type, latitude: latitude, longitude: longitude), LL: LL, type: type, startedEvent: startedEvent, postedWait: postedWait, singleRider: singleRider))
        }
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        showError = false
        selectedTab = .home
        presentationMode.wrappedValue.dismiss()
        
    }
    
    func can_add_another_schedule() -> Bool {
        if dayListViewModel.get_day(day_id: day_id).scheduleList.count == 0 {
            return true
        }
        let schedule = dayListViewModel.get_day(day_id: day_id).scheduleList[dayListViewModel.get_day(day_id: day_id).scheduleList.count - 1]
        return schedule.endedEvent != nil
    }
}


