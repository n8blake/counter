//
//  ContentView.swift
//  counter WatchKit Extension
//
//  Created by Nathan Blake on 6/3/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var counterStore = CounterStore()
    let colors: [ColorLabel] = [ColorLabel(color: Color("Blue"), label: "Blue"), ColorLabel(color: Color("Green"), label: "Green"), ColorLabel(color: Color("Yellow"), label: "Yellow"), ColorLabel(color: Color("Red"), label: "Red")]
    
    var body: some View {
        VStack {
            Text("\(counterStore.activeCounter.count)")
                .font(.system(size: 65))
                .foregroundColor(Color("\(counterStore.activeCounter.color)FG"))
                .padding()
            Spacer()
            HStack {
                //let btnBorderColor = counterStore.activeCounter.color
                // These are the counter nav buttons
                ForEach(colors, id: \.self) { color in
                    Button("\(counterStore.getCountForColor(color: color.label) ?? 0)") {
                        counterStore.changeActiveColor(color: color.label)
                    }
                    .buttonStyle(BorderedButtonStyle(tint: Color("\(color.label)FG")))
                    //.digitalCrownRotation()
                }
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
