//
//  WatchConnectivityManager.swift
//  counter
//
//  Created by Nathan Blake on 6/7/22.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var updatedCounts: [String : Counter]? = nil
    
    private override init(){
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func send(_ userInfo: [String : Counter] = [:]) {
        guard WCSession.default.activationState == .activated else {
            return
        }
        #if os(iOS)
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
        #else
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
        #endif
        
        let result = WCSession.default.transferUserInfo(userInfo)
        print(String(describing: result))
    }
    
    func clearUpdatedCounts() {
        self.updatedCounts = nil
    }
    
}

extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if userInfo is [String : Counter] {
            DispatchQueue.main.async { [weak self] in
                self?.updatedCounts = userInfo as? [String : Counter]
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){}
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
