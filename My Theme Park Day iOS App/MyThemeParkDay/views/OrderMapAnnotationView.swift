//
//  OrderMapAnnotationView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/28/24.
//

import SwiftUI
import MapKit

struct OrderMapAnnotationView: View {
    
//    @Binding var mapRegion: MKCoordinateRegion
    let event: EventModel
    let orderNumber: String
//    @Binding var selectedEvent: EventModel?
    var body: some View {
        VStack {
            if(event.type == "Attraction") {
                Text(orderNumber)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
//                    .font(.headline)
//                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.blue)
//                    .clipShape(Circle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .onTapGesture {
                        tap_event()
                    }
            } else if event.type == "Food" {
                Text(orderNumber)
                //                    .resizable()
                //                    .scaledToFit()
                //                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                //                    .font(.headline)
                //                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.yellow)
                //                    .clipShape(Circle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .onTapGesture {
                        tap_event()
                    }
            } else if event.type == "Entertainment" {
                Text(orderNumber)
                //                    .resizable()
                //                    .scaledToFit()
                //                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                //                    .font(.headline)
                //                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.red)
                //                    .clipShape(Circle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .onTapGesture {
                        tap_event()
                    }
            } else {
                Text(orderNumber)
                //                    .resizable()
                //                    .scaledToFit()
                //                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                //                    .font(.headline)
                //                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.gray)
                //                    .clipShape(Circle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
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
//        withAnimation(.easeInOut(duration: 0.5)) {
//            selectedEvent = event
//            if event.latitude != nil && event.longitude != nil {
//                mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: event.latitude!, longitude: event.longitude!), span: mapRegion.span)
//            }
//        }
    }
}
