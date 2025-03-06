//
//  MyThemeParkDayApp.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/4/24.
//

import SwiftUI

@main
struct MyThemeParkDay: App {
    
    @State var dayListViewModel: DayListViewModel = DayListViewModel()
    @State var photoGroupViewModel: PhotoGroupViewModel = PhotoGroupViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DayListView()
            }
            .environmentObject(dayListViewModel)
            .environmentObject(photoGroupViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait //By default you want all your views to rotate freely
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
