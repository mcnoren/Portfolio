//
//  AddDayView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/5/24.
//

import SwiftUI

struct AddDayView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    @State var parks: [String] = []
    @State var date = Date()
    @State var parkName: String = ""
    let calendar = Calendar.current
    @State var showAddTemplateView: Bool = false
    @State var showTemplateView: Bool = false
    @State var parkBools: [String: Bool] = [:]
    @State var allParks: [String] = []
    @State var replaceConfirmation: Bool = false
    
    var body: some View {
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
                    Button("Add", action: saveButtonPressed)
                        .padding(10)
                        .disabled(parksIsEmpty())
                }
                Text("New Day")
                    .font(.largeTitle)
                    .bold()
                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .padding(10)
                
                HStack {
                    Text("Select Parks")
                        .font(.title2)
                        .padding(.leading, 10)
                    Spacer()
//                    Button{
//                        parkName = ""
//                        showAddTemplateView = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                if allParks.isEmpty {
                    Text("No Parks")
                        .padding()
                }
                ScrollView {
                    ForEach(allParks, id: \.self) { park in
                        HStack {
                            HStack {
                                if parkBools[park] != nil && parkBools[park]! {
                                    ZStack {
                                        Image(systemName: "checkmark.circle")
                                            .font(.title2)
                                    }
                                } else {
                                    Image(systemName: "circle")
                                        .font(.title2)
                                }
                                Text(park)
                                Spacer()
                            }
                            .frame(minWidth: UIScreen.main.bounds.width - 80)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if parkBools[park] == nil {
                                    parkBools[park] = false
                                }
                                parkBools[park]?.toggle()
                            }
                            Spacer()
                            ParkListRowView(parks: $allParks, park: park)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                    }
                }
            }
        }
//        .sheet(isPresented: $showAddTemplateView, content: {
//            AddTemplateView(allParks: $allParks)
//        })
//        .alert("New Park", isPresented: $showAddTemplateView) {
//            TextField("Park Name", text: $parkName)
//            Button("OK", action: addParkButton)
//            .disabled(parkName.isEmpty)
//            Button("Cancel", role: .cancel) { }
//        } message: {
//            Text("Please enter the name of the park.")
//        }
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog("Delete", isPresented: $replaceConfirmation, titleVisibility: .hidden) {
                Button("Replace", role: .destructive) {
                    eventListViewModel.addPark(parkName: parkName)
                    allParks.append(parkName)
                }
        } message: {
            Text("The park \(parkName) already Exists on this device. Are you sure you want to replace it?")
        }
        .onAppear {
            allParks = EventListViewModel().parks
            for park in allParks {
                parkBools[park] = false
            }
        }
    }
    func saveButtonPressed() {
        var title: String = ""
        parks = []
        for (park, b) in parkBools {
            if b {
                parks.append(park)
            }
        }
        var i = 0
        for park in parks {
            if i != 0{
                title += ", "
            }
            title += park
            i += 1
        }
        let id = UUID().uuidString
        dayListViewModel.addDay(id: id, parks: parks, title: title, date: date)
//        PhotoGroupViewModel().addPhotoGroup(photo_model: PhotoModel(day_id: id))
        presentationMode.wrappedValue.dismiss()
    }
    
    func addParkButton() {
        if allParks.contains(parkName) {
            replaceConfirmation = true
        } else {
            eventListViewModel.addPark(parkName: parkName)
            allParks.append(parkName)
        }
    }
    
    func parksIsEmpty() -> Bool {
        for (park, b) in parkBools {
            if b {
                return false
            }
        }
        return true
    }
}
