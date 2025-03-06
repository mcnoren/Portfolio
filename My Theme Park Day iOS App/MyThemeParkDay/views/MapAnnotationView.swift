//
//  MapAnnotationView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/29/24.
//

import SwiftUI
import MapKit

struct MapAnnotationView: View {
    
    @Binding var mapRegion: MKCoordinateRegion
    let event: EventModel
    @Binding var selectedEvent: EventModel?
    var body: some View {
        VStack {
            if(event.type == "Attraction") {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(.blue)
                    .clipShape(Circle())
                    .onTapGesture {
                        tap_event()
                    }
            } else if event.type == "Food" {
                Image(systemName: "fork.knife")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(.yellow)
                    .clipShape(Circle())
                    .onTapGesture {
                        tap_event()
                    }
            } else if event.type == "Entertainment" {
                Image(systemName: "wand.and.stars.inverse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(.red)
                    .clipShape(Circle())
                    .onTapGesture {
                        tap_event()
                    }
            } else {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(.gray)
                    .clipShape(Circle())
                    .onTapGesture {
                        tap_event()
                    }
            }
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(event.type == "Attraction" ? .blue : event.type == "Food" ? .yellow : event.type == "Entertainment" ? .red : .gray)
                .frame(width: 11, height: 16)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -14)
        }
        .offset(y: -10)
    }
    func tap_event() {
        withAnimation(.easeInOut(duration: 0.5)) {
            selectedEvent = event
            if event.latitude != nil && event.longitude != nil {
                mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: event.latitude!, longitude: event.longitude!), span: mapRegion.span)
            }
        }
    }
}
