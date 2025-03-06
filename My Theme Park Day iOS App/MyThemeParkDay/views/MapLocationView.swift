//
//  MapLocationView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/29/24.
//

import SwiftUI
import MapKit

struct MapLocationView: View {
    
    @Binding var selectedEvent: EventModel?
    @Binding var pickedEvent: EventModel?
    @Binding var showAddScheduleView: Bool
    @Binding var mapRegion: MKCoordinateRegion
    @State var onLocation: Bool = false
    var body: some View {
        HStack {
            if selectedEvent != nil{
                VStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Button(action: {
                                selectedEvent = nil
                            }, label: {
                                Image(systemName: "x.circle")
                                    .foregroundStyle(.red)
                                    .backgroundStyle(.white)
                                    .font(.title)
                            })
                            Spacer()
                        }
                    }
                    .offset(x: 10.0, y: 20)
                    ZStack {
                        VStack(alignment: .leading){
                            Text("\(selectedEvent!.name)")
                                .font(.title)
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(selectedEvent!.type)")
                                    Text("\(selectedEvent!.land)")
                                }
                                Spacer()
                                Button {
                                    pickedEvent = selectedEvent
                                    selectedEvent = nil
                                    showAddScheduleView = true
                                } label: {
                                    Text("Use Template")
                                        .foregroundStyle(.white)
                                        .padding(10)
                                        .frame(width: 150, height: 45)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10.0)
                                                .fill(.blue)
                                        )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color(.systemGray6))
                        )
                        .padding()
                        
                        
                    }
                }
            }
            if selectedEvent != nil && (onLocation && (mapRegion.center.latitude != selectedEvent!.latitude! || mapRegion.center.longitude != selectedEvent!.longitude!)) {
                ZStack {}
                .onAppear {
                    selectedEvent = nil
                    onLocation = false
                }
            }
            if selectedEvent != nil && onLocation == false && mapRegion.center.latitude == selectedEvent!.latitude! && mapRegion.center.longitude == selectedEvent!.longitude! {
                ZStack {}
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
                        if selectedEvent != nil {
                            mapRegion.center = CLLocationCoordinate2D(latitude: selectedEvent!.latitude!, longitude: selectedEvent!.longitude!)
                            onLocation = true
                        }
                    }
                }
            }
        }
        .onChange(of: selectedEvent, {
            onLocation = false
        })
        .animation(.easeInOut, value: selectedEvent)
    }
}
