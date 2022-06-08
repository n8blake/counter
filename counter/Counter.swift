//
//  Counter.swift
//  counter
//
//  Created by Nathan Blake on 6/3/22.
//

import Foundation
import SwiftUI

class CounterStore: ObservableObject {

    @Published var activeCounter: Counter
    @Published var activeCounterColor: ColorLabel
    
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    private var countersDictionary: [String : Counter] = [:]
    
    init() {
        // Retrive each of the counters
        let blueCounter = UserDefaults.standard.integer(forKey: "Blue")
        countersDictionary["Blue"] = Counter(count: blueCounter, color:"Blue")
        let greenCounter = UserDefaults.standard.integer(forKey: "Green")
        countersDictionary["Green"] = Counter(count: greenCounter, color:"Green")
        let yellowCounter = UserDefaults.standard.integer(forKey: "Yellow")
        countersDictionary["Yellow"] = Counter(count: yellowCounter, color:"Yellow")
        let redCounter = UserDefaults.standard.integer(forKey: "Red")
        countersDictionary["Red"] = Counter(count: redCounter, color:"Red")
        
        // set active counter
        if let activeCounterColorString = UserDefaults.standard.string(forKey: "ActiveCounterColor") {
            activeCounterColor = ColorLabel(color: Color("\(activeCounterColorString)"), label: activeCounterColorString)
            activeCounter = countersDictionary[activeCounterColorString] ?? Counter(count: -100, color: "Red")
        } else {
            UserDefaults.standard.set("Blue", forKey: "ActiveCounterColor")
            activeCounter = countersDictionary["Blue"] ?? Counter(count: 0, color: "Blue")
            activeCounterColor = ColorLabel(color: Color("Blue"), label: "Blue")
        }
        
    }
    
    func increase() {
        activeCounter.count = activeCounter.count + 1
        self.setColorCount(color: activeCounter.color, count: activeCounter.count)
    }
    
    func decrease() {
        activeCounter.count = activeCounter.count - 1
        self.setColorCount(color: activeCounter.color, count: activeCounter.count)
    }
    
    func setColorCount(color: String, count: Int){
        countersDictionary[color]?.count = count
        UserDefaults.standard.set(count, forKey: color)
        // send data to other device
        connectivityManager.send(countersDictionary)
    }
    
    func getCountForColor(color: String) -> Int? {
        countersDictionary = WatchConnectivityManager.shared.updatedCounts ?? countersDictionary
        if((WatchConnectivityManager.shared.updatedCounts) != nil){
            WatchConnectivityManager.shared.clearUpdatedCounts()
        }
        return countersDictionary[color]?.count
    }
    
    func changeActiveColor(color: String) {
        activeCounterColor = ColorLabel(color: Color("\(color)"), label: color)
        activeCounter = countersDictionary[color] ?? Counter(count: 0, color: "Blue")
        UserDefaults.standard.set(color, forKey: "ActiveCounterColor")
    }

}

struct Counter: Codable {
    var count: Int
    let color: String
}

struct ColorLabel: Comparable, Hashable {
    var color: Color
    var label: String
    
    static func <(lhs: ColorLabel, rhs: ColorLabel) -> Bool {
        return lhs.label < rhs.label
    }
    
}

//let colors: [String: Color] = ["Blue": Color("Blue"), "Green" : Color("Green"), "Yellow": Color("Yellow"),"Red":Color("Red")]
