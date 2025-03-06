//
//  WatchConnector.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 4/1/24.
//

import Foundation
import WatchConnectivity
import SwiftData

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    var modelContext: ModelContext? = nil
    
    init(session: WCSession = .default) {
        
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let date = message["Date"] as? Date ?? Date()
//        modelContext?.insert(date)
    }
}
