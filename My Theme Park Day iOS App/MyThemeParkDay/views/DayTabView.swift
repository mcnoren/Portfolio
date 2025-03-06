//
//  TabView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/7/24.
//

import SwiftUI

enum Tabs: String {
    case home
    case templates
    case map
    case stats
    case settings
}

struct DayTabView: View {
    
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    let day: DayModel
    @State var selectedTab: Tabs = .home
    @State var showPhotoView: Bool = false
    @State var photoTab: Data?
    
    var body: some View {
        ZStack {
//            if showPhotoView {
////                StatsPhotoView(showPhotoView: $showPhotoView, selectedPhoto: $photoTab, day_id: day.id)
//            } else {
            
                TabView(selection: $selectedTab) {
                    DayHomeView(selectedTab: $selectedTab, day: day)
                        .tabItem {
                            Image(systemName: "list.star")
                            Text("Schedule")
                        }
                        .tag(Tabs.home)
                    AttractionListView(selectedTab: $selectedTab, day: day, events: EventListViewModel().events)
                        .tabItem {
                            Image(systemName: "star.fill")
                                .backgroundStyle(Color("6320eb"))
                            Text("Add Event")
                        }
                        .tag(Tabs.templates)
//                    MapView(selectedTab: $selectedTab, day: day, events: EventListViewModel().events)
//                        .tabItem {
//                            Image(systemName: "map")
//                            Text("Map")
//                        }
//                        .tag(Tabs.map)
                    StatsView(selectedTab: $selectedTab, day: dayListViewModel.get_day(day_id: day.id), notes: dayListViewModel.get_day(day_id: day.id).notes, tab: $photoTab, showPhotoView: $showPhotoView)
                        .tabItem {
                            Image(systemName: "chart.pie.fill")
                            Text("Overview")
                        }
                        .tag(Tabs.stats)
                    
                }
                .backgroundStyle(Color(.systemBackground))
                .toolbar(.hidden, for: .navigationBar)
            }
        .onAppear {
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().barTintColor = UIColor(named: "Secondary")
        }
//        }
//        .overlay(
//            ZStack {
//                if showPhotoView {
//                    StatsPhotoView(showPhotoView: $showPhotoView, selectedPhoto: $photoTab, day_id: day.id)
//                    .onAppear {
//                        AppDelegate.orientationLock = .allButUpsideDown
//                    }
//                    .onDisappear {
//                        AppDelegate.orientationLock = .portrait
//                    }
//                }
//            }
//        )
        
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
