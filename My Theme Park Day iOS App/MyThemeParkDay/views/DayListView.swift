//
//  DayListView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/5/24.
//

import SwiftUI

struct DayListView: View {
    
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    @State var showAddDayView: Bool = false
    @State var showTemplatesView: Bool = false
    @State var showConfirmation: Bool = false
    @State var editing = false
    @State var day_id: String?
    @State var typing: Bool = false
    @State var showNoParksError: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                if dayListViewModel.days.isEmpty {
                    Spacer()
                    Text("No Items")
                } else {
                    List {
                        ForEach(dayListViewModel.days) { day in
                            HStack {
                                if editing {
                                    Image(systemName: "minus.circle.fill")
                                        .padding(.horizontal, 10)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: 30)
                                        .onTapGesture {
                                            day_id = day.id
                                            showConfirmation.toggle()
                                        }
                                    DayListRowView(day_id: day.id, day_date: day.date, day_title: dayListViewModel.get_day(day_id: day.id).title, typing: $typing)
                                        .frame(height: 70)
                                    
                                    
                                } else {
                                    NavigationLink(value: day) {
                                        DayListRowView(day_id: day.id, day_date: day.date, day_title: dayListViewModel.get_day(day_id: day.id).title, typing: $typing)
                                            .frame(height: 70)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                //            if isloading {
                //                ProgressView()
                //                    .progressViewStyle(CircularProgressViewStyle())
                //                    .scaleEffect(2)
                //            }
                Spacer()
//                HStack {
//                    Spacer()
//                    NavigationLink {
//                        TemplatesView()
//                    } label: {
//                        Image(systemName: "list.bullet.clipboard")
//                            .padding(10)
//                    }
//                    
//                }
            }
        }
//        .onAppear {
//            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//            AppDelegate.orientationLock = .portrait
//        }
//        .onDisappear {
//            AppDelegate.orientationLock = .allButUpsideDown
//        }
        .confirmationDialog("Delete", isPresented: $showConfirmation, titleVisibility: .hidden) {
            Button("Delete", role: .destructive) {
                DispatchQueue.main.async{
                    photoGroupViewModel.delete_all_photo_refs_for_day(day_id: day_id!)
                    dayListViewModel.deleteDay(day_id: day_id!)
                    editing = false
                    typing = false
                }
            }
        } message: {
            Text("Are you sure you want to delete this item?")
        }
            .navigationBarTitle("Days")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        editing.toggle()
                        typing.toggle()
                    }, label: {
                        Text(editing ? "Done" : "Edit")
                    })
                    .disabled(dayListViewModel.days.isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        TemplatesView()
                    } label: {
                        Image(systemName: "list.bullet.clipboard")
                            .padding(10)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if EventListViewModel().parks.isEmpty {
                            showNoParksError = true
                        } else {
                            showAddDayView = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("No Parks", isPresented: $showNoParksError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("There are no parks on this device. Press the clipboard at the top to view/add your parks.")
            }
            .sheet(isPresented: $showAddDayView, content: {
                AddDayView()
                    .environmentObject(dayListViewModel)
            })
            .sheet(isPresented: $showTemplatesView, content: {
                TemplatesView()
            })
            .navigationDestination(for: DayModel.self) { day in
                DayTabView(day: day)
                    .environmentObject(dayListViewModel)
                    .environmentObject(photoGroupViewModel)
            }
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.gray)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(.gray).withAlphaComponent(0.2)
            }
        
            
            
    }
}
