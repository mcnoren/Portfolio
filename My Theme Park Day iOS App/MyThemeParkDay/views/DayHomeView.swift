//
//  DayHomeView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/7/24.
//

import SwiftUI

struct DayHomeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    @State var showAddScheduleView: Bool = false
    @State var edit: Bool = false
    @Binding var selectedTab: Tabs
    @State var dictCounts: [String : Int] = [:]
    let day: DayModel
    @State var showExitConfirmation: Bool = false
    
    var body: some View {
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
                    Button(action: {
                        withAnimation(.snappy(duration: !edit ? 0.2 : 0.6)) {
                            edit.toggle()
                        }
                    }, label: {
                        Text(edit ? "Done" : "Edit")
                            .padding(.trailing, 10)
                    })
                    .frame(width: 70)
                }
                HStack {
                    Text("Schedule")
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading, 10)
                        .padding(.vertical, 5)
                    Spacer()
//                    Menu {
//                        Section("Park Times") {
//                            ForEach(dayListViewModel.get_day(day_id: day.id).parks, id: \.self) {park in
//                                Menu() {
//                                    Button {
//                                        dayListViewModel.enterPark(day: day, park: park)
//                                    } label: {
//                                        Text("In")
//                                    }.disabled(!dayListViewModel.get_day(day_id: day.id).currentPark.isEmpty)
//                                    Button {
//                                        dayListViewModel.enterPark(day: day, park: "")
//                                    } label: {
//                                        Text("Out")
//                                    }.disabled(dayListViewModel.get_day(day_id: day.id).currentPark != park)
//                                    
//                                } label: {
//                                    Text(park)
//                                }
//                            }
//                        }
//                        
//                    } label: {
//                        Image(systemName: "clock")
//                    }.padding(10)
                    
                    
//                    Button(action: {
//                        showAddScheduleView = true
//                    }, label: {
//                        Image(systemName: "plus")
//                            .padding(10)
//                            .font(.title2)
//                    })
                }
                Spacer()
//                if(dayListViewModel.get_day(day_id: day.id).get_scheduleList().isEmpty) {
//                    Text("No Items")
//                } else {
                    ScrollView {
                        ForEach(dayListViewModel.get_day(day_id: day.id).get_scheduleList()) { schedule in
                            ForEach(day.parks, id: \.self) { park in
                                
                            }
                            if schedule.endedEvent != nil {
                                ScheduleListRowView(day: day, schedule: schedule, edit: $edit)
                                    
                            }
                        }
                        Button( action: {
                            if !dayListViewModel.get_day(day_id: day.id).currentPark.isEmpty {
                                showExitConfirmation = true
                            }
                        }, label: {
                            if dayListViewModel.get_day(day_id: day.id).currentPark.isEmpty {
                                Menu() {
                                    ForEach(dayListViewModel.get_day(day_id: day.id).parks, id: \.self) {park in
                                        Button {
                                            dayListViewModel.enterPark(day: day, park: park)
                                        } label: {
                                            Text("\(park)")
                                        }
                                    }
                                } label: {
                                    Text("Enter Park")
                                }
                            } else {
                                Text("Exit \(dayListViewModel.get_day(day_id: day.id).currentPark)")
                            }
                        }).disabled(!dayListViewModel.canEnterPark(day_id: day.id))
                            .padding(.bottom, 30)
                            .padding(.top, 15)
                    }
//                }
                Spacer()
                ForEach(dayListViewModel.get_day(day_id: day.id).get_scheduleList()) { schedule in
                    if schedule.endedEvent == nil {
                        ScheduleListRowView(day: day, schedule: schedule, edit: $edit)
                            
                    }
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
        .onAppear(perform: {
            for park in day.parks {
                dictCounts[park] = 0
            }
        })
        .sheet(isPresented: $showAddScheduleView, content: {
            AddScheduleView(day_id: day.id, selectedTab: $selectedTab, park: dayListViewModel.get_day(day_id: day.id).currentPark)
        
        })
        .confirmationDialog("Exit", isPresented: $showExitConfirmation, titleVisibility: .hidden) {
            Button("Exit", role: .destructive) {
                dayListViewModel.enterPark(day: day, park: "")
            }
        } message: {
            Text("Are you sure you want to exit \(dayListViewModel.get_day(day_id: day.id).currentPark)?")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
}

