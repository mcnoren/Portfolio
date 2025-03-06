//
//  MapView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @StateObject private var viewModel = MapViewModel()
    @Binding var selectedTab: Tabs
    @State var showAddScheduleView: Bool = false
    var day: DayModel
    @Binding var sort: String
    let sortList: [String] = ["Attractions", "Food", "Entertainment", "Lightning Lane", "Single Rider"]
    @State var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.809135, longitude: -117.918966), span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
    @State var events: [EventModel]
    @State var selectedEvent: EventModel?
    @State var pickedEvent: EventModel?
    @Binding var searchText: String
    @Binding var barIsFocused: Bool
    
    var body: some View {
        VStack {
//            HStack {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    Image(systemName: "chevron.backward")
//                        .padding(.leading, 10)
//                        .bold()
//                    Text("Back")
//                })
//                Spacer()
//            }
//            HStack {
//                Text("Map")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.leading, 10)
//                    .padding(.bottom, 5)
//                Spacer()
//                Picker(selection: $sort, content: {
//                    ForEach(sortList, id: \.self) {
//                        Text($0)
//                    }
//                }, label: {
//                    Image(systemName: "ellipsis.circle")
//                        .padding(10)
//                })
//            }
            ZStack {
                Map(coordinateRegion: $mapRegion,
                    showsUserLocation: true,
                    annotationItems: events,
                    annotationContent: { event in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.latitude != nil ? event.latitude! : 0, longitude: event.longitude != nil ? event.longitude! : 0)) {
                        MapAnnotationView(mapRegion: $mapRegion, event: event, selectedEvent: $selectedEvent)
                            .scaleEffect(selectedEvent == event ? 1.5 : 0.9)
                            .shadow(radius: 10)
                            .animation(.bouncy(duration: 0.3), value: selectedEvent == event)
                    }
                })
                .mapControls {
                    MapUserLocationButton()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                mapRegion = MKCoordinateRegion(center: mapRegion.center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
                            }
                        }
                    MapCompass()
                }
                //            .mapStyle(.standard(pointsOfInterest: .excludingAll))
                .mapStyle(.imagery)
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
                VStack {
                    Spacer()
                    MapLocationView(selectedEvent: $selectedEvent, pickedEvent: $pickedEvent, showAddScheduleView: $showAddScheduleView, mapRegion: $mapRegion)
                }
            }
        }
//        .onAppear {
//            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//            AppDelegate.orientationLock = .portrait
//        }
//        .onDisappear {
//            AppDelegate.orientationLock = .allButUpsideDown
//        }
        .sheet(isPresented: $showAddScheduleView, content: {
            AddScheduleView(day_id: day.id, selectedTab: $selectedTab, name: pickedEvent!.name, park: pickedEvent!.park, land: pickedEvent!.land, type: pickedEvent!.type, latitude: pickedEvent!.latitude, longitude: pickedEvent!.longitude)
        })
        .onChange(of: selectedEvent, {
            if selectedEvent != nil {
                barIsFocused = false
            }
        })
        .onChange(of: barIsFocused, {
            if barIsFocused {
                selectedEvent = nil
            }
        })
        .onAppear {
            if sort == "All" {
                sort = "Attractions"
            }
            var max_long: Double = -180
            var min_long: Double = 180
            var max_lat: Double = -90
            var min_lat: Double = 90
            events = []
            let all_events = EventListViewModel().eventsForPark(parkName: dayListViewModel.get_day(day_id: day.id).currentPark)
            for event in all_events {
                if event.longitude != nil {
                    if event.longitude! > max_long {
                        max_long = event.longitude!
                    }
                    if event.longitude! < min_long {
                        min_long = event.longitude!
                    }
                }
                if event.latitude != nil {
                    if event.latitude! > max_lat {
                        max_lat = event.latitude!
                    }
                    if event.latitude! < min_lat {
                        min_lat = event.latitude!
                    }
                }
                if sort == "All" || sort == "Lightning Lane" && event.LL || sort == "Attractions" && event.type == "Attraction" || sort == "Food" && event.type == "Food" || sort == "Entertainment" && event.type == "Entertainment" || sort == "Single Rider" && event.singleRider{
                    if searchText.isEmpty || event.name.lowercased().contains(searchText.lowercased()) {
                        events.append(event)
                    }
                }
            }
            if max_long != -180 {
                mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (min_lat + max_lat) / 2, longitude: (min_long + max_long) / 2), span: MKCoordinateSpan(latitudeDelta: max_lat - min_lat + 0.002, longitudeDelta: max_long - min_long + 0.002))
            }
        }
        .onChange(of: sort) {
            events = []
            let all_events = EventListViewModel().eventsForPark(parkName: dayListViewModel.get_day(day_id: day.id).currentPark)
            for event in all_events {
                if sort == "All" || sort == "Lightning Lane" && event.LL || sort == "Attractions" && event.type == "Attraction" || sort == "Food" && event.type == "Food" || sort == "Entertainment" && event.type == "Entertainment" || sort == "Single Rider" && event.singleRider {
                    if searchText.isEmpty || event.name.lowercased().contains(searchText.lowercased()) {
                        events.append(event)
                    }
                }
            }
        }
        .onChange(of: searchText) {
            events = []
            let all_events = EventListViewModel().eventsForPark(parkName: dayListViewModel.get_day(day_id: day.id).currentPark)
            for event in all_events {
                if sort == "All" || sort == "Lightning Lane" && event.LL || sort == "Attractions" && event.type == "Attraction" || sort == "Food" && event.type == "Food" || sort == "Entertainment" && event.type == "Entertainment" || sort == "Single Rider" && event.singleRider {
                    if searchText.isEmpty || event.name.lowercased().contains(searchText.lowercased()) {
                        events.append(event)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)

    }
    
    
    
    
}



//#Preview {
//    MapView()
//}
