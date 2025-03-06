//
//  ScheduleListRowView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/8/24.
//

import SwiftUI

struct ScheduleListRowView: View {
    
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let day: DayModel
    let schedule: ScheduleModel
    let calendar = Calendar.current
    @State var showConfirmation: Bool = false
    @Binding var edit: Bool
    @State var secondsWaited: Int = 0
    @State var animateOpacity: Bool = true
    
    var body: some View {
            ZStack {
                VStack {
                    Divider()
                    HStack {
                        VStack {
                            if(edit && schedule.type != "Entry") {
                                Button(action: {
                                    showConfirmation = true
                                }, label: {
                                    Image(systemName: "minus.circle.fill")
                                        .padding(.horizontal,
                                                 10)
                                        .foregroundColor(.red)
                                })
                            }
                        }
                        VStack {
                            if(schedule.type == "Attraction") {
                                Image(systemName: "star.fill")
                                    .font(.title3)
                                    .padding(.horizontal, 5)
                            } else if schedule.type == "Food" {
                                Image(systemName: "fork.knife")
                                    .font(.title3)
                                    .padding(.horizontal, 5)
                            } else if schedule.type == "Entertainment" {
                                Image(systemName: "wand.and.stars.inverse")
                                    .font(.title3)
                                    .padding(.horizontal, 5)
                            } else if schedule.type == "Entry" {
                                Image(systemName: "clock")
                                    .font(.title3)
                                    .padding(.horizontal, 5)
                                    .padding(.top, 5)
                            }
                            if(schedule.startedWaiting != nil) {
                                HStack {
                                    
                                    TimeView(date: schedule.startedWaiting!)
                                        .font(.subheadline)
                                        .padding(5)
                                }
                            } else if schedule.startedEvent != nil {
                                HStack {
                                    TimeView(date: schedule.startedEvent!)
                                        .font(.subheadline)
                                        .padding(5)
                                }
                            } else if schedule.endedEvent != nil {
                                HStack {
                                    TimeView(date: schedule.endedEvent!)
                                        .font(.subheadline)
                                        .padding(5)
                                }
                            }
                            
                        }
                        
                        
                        
                        VStack {
                            HStack {
                                
                                Text(schedule.event.name)
                                    .bold()
                                    .font(schedule.type == "Entry" ? .body : .title3)
                                if(schedule.LL) {
                                    Text("LL")
                                        .font(.system(size: 24, weight: .heavy))
                                        .italic()
                                        .foregroundColor(.blue)
                                        .padding(.leading, 5)
                                }
                                if schedule.singleRider {
                                    Text("S")
                                        .font(.system(size: 24, weight: .heavy))
                                        .italic()
                                        .foregroundColor(.blue)
                                        .padding(.leading, 5)
                                }
                                Spacer()
                            }
                            if schedule.startedWaiting != nil {
                                HStack {
                                    Text("Time Waited: ")
                                        .font(.subheadline)
                                    if(schedule.startedWaiting != nil && schedule.startedEvent != nil) {
                                        Text("\(Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min \(Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!))%60) sec")
                                            .font(.subheadline)
                                    } else if schedule.startedWaiting != nil && schedule.endedEvent != nil {
                                        Text("\(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min \(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))%60) sec")
                                            .font(.subheadline)
                                    } else if schedule.startedWaiting != nil {
                                        Text("\(secondsWaited/60) min \(secondsWaited%60) sec")
                                            .font(.subheadline)
                                            .onReceive(timer) { _ in
                                                secondsWaited = Int(Date().timeIntervalSince(schedule.startedWaiting!))
                                            }
                                            .onAppear() {
                                                secondsWaited = Int(Date().timeIntervalSince(schedule.startedWaiting!))
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            if schedule.type != "Entry" && !(schedule.aborted && schedule.startedEvent == nil){
                                HStack {
                                    Text("Duration:")
                                        .font(.subheadline)
                                    if(schedule.startedEvent != nil && schedule.endedEvent != nil) {
                                        Text("\(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!))/60) min \(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!))%60) sec")
                                            .font(.subheadline)
                                    } else if schedule.startedEvent != nil {
                                        Text("\(secondsWaited/60) min \(secondsWaited%60) sec")
                                            .font(.subheadline)
                                            .onReceive(timer) { _ in
                                                secondsWaited = Int(Date().timeIntervalSince(schedule.startedEvent!))
                                            }
                                            .onAppear() {
                                                secondsWaited = Int(Date().timeIntervalSince(schedule.startedEvent!))
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            if schedule.ride_broke_in_line {
                                HStack {
                                    Text("*Broke Down in line")
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                            if schedule.ride_broke_on_ride {
                                HStack {
                                    Text("*Broke Down on ride")
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                            if schedule.aborted {
                                HStack {
                                    Text("*Left")
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                        
                            
                            
                        }
                        .padding(10)
                        if edit == false && schedule.type != "Entry"{
                            NavigationLink {
                                ScheduleView(day_id: day.id, schedule: schedule, notes: schedule.notes)
                                    .environmentObject(dayListViewModel)
                                    .environmentObject(photoGroupViewModel)
                            } label: {
                                Image(systemName: "info.circle")
                                    .padding(.trailing, 20)
                            }
                            
                        }
                        
                    }
                    if schedule.type != "Entry" && !schedule.aborted{
                        if(schedule.startedEvent == nil) {
                            HStack {
                                if schedule.type == "Atraction" {
                                    Text("In Line...")
                                        .font(.subheadline)
                                        .foregroundStyle(.blue)
                                        .padding(.leading, 55.0)
                                        .padding(.bottom, 10)
                                        .opacity(animateOpacity ? 1.0 : 0.5)
                                } else {
                                    Text("Waiting...")
                                        .font(.subheadline)
                                        .foregroundStyle(.blue)
                                        .padding(.leading, 55.0)
                                        .padding(.bottom, 10)
                                        .opacity(animateOpacity ? 1.0 : 0.5)
                                }
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    dayListViewModel.change_schedule_startedEvent(day_id: day.id, schedule_id: schedule.id, startedEvent: Date())
                                }, label: {
                                    if schedule.type == "Attraction" {
                                        Text("On Ride")
                                            .tint(.white)
                                    } else {
                                        Text("Started")
                                            .tint(.white)
                                    }
                                })
                                .padding()
                                .frame(width: 130, height: 40)
                                .background(Color(red: 0, green: 0, blue: 40))
                                .clipShape(Capsule())
                                .padding(.trailing, 30.0)
                                .padding(.bottom, 10)
                            }
                        } else {
                            if(schedule.endedEvent == nil) {
                                HStack {
                                    if schedule.type == "Attraction" {
                                        Text("On ride...")
                                            .font(.subheadline)
                                            .foregroundStyle(.blue)
                                            .padding(.leading, 55.0)
                                            .padding(.bottom, 10)
                                            .opacity(animateOpacity ? 1.0 : 0.5)
                                    } else {
                                        Text("In Progress...")
                                            .font(.subheadline)
                                            .foregroundStyle(.blue)
                                            .padding(.leading, 55.0)
                                            .padding(.bottom, 10)
                                            .opacity(animateOpacity ? 1.0 : 0.5)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        dayListViewModel.change_schedule_endedEvent(day_id: day.id, schedule_id: schedule.id, endedEvent: Date())
                                    }, label: {
                                        if schedule.type == "Attraction" {
                                            Text("Ride Over")
                                                .tint(.white)
                                        } else {
                                            Text("End")
                                                .tint(.white)
                                        }
                                    })
                                    .padding()
                                    .frame(width: 130.0, height: 40)
                                    .background(Color(red: 0, green: 0, blue: 40))
                                    .clipShape(Capsule())
                                    .padding(.trailing, 30.0)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                    
                }
            }
            .confirmationDialog("Delete", isPresented: $showConfirmation, titleVisibility: .hidden) {
                Button("Delete", role: .destructive) {
                    withAnimation{
                        photoGroupViewModel.delete_ref_photo_group(day_id: day.id, schedule_id: schedule.id)
                        dayListViewModel.delete_schedule(day_id: day.id, schedule_id: schedule.id)
                        edit = false
                    }
                }
            } message: {
                Text("Are you sure you want to delete \(schedule.event.name)?")
            }
            .animation(.easeIn(duration: 2.0).repeatForever(autoreverses: true), value: animateOpacity)
    }
}
