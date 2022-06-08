//
//  ContentView.swift
//  counter
//
//  Created by Nathan Blake on 6/3/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var counterStore = CounterStore()
    
    let colors: [ColorLabel] = [ColorLabel(color: Color("Blue"), label: "Blue"), ColorLabel(color: Color("Green"), label: "Green"), ColorLabel(color: Color("Yellow"), label: "Yellow"), ColorLabel(color: Color("Red"), label: "Red")]

    var body: some View {
        VStack{
            Spacer()
            Text("\(counterStore.activeCounter.count)")
                .font(.system(size: 120))
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Spacer()
            HStack {
                let btnColor = counterStore.activeCounter.color
                Button {
                    counterStore.decrease()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "minus")
                            .font(.system(size: 60))
                            .frame(width: 125, height: 125, alignment: .center)
                            .foregroundColor(Color("\(btnColor)FG"))
                        Spacer()
                    }
                    .padding()
                    .background(Color("\(btnColor)"))
                    .clipShape(Circle())
                }
                Spacer()
                Button {
                    counterStore.increase()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .font(.system(size: 60))
                            .frame(width: 125, height: 125, alignment: .center)
                            .foregroundColor(Color("\(btnColor)FG"))
                        Spacer()
                    }
                    .padding()
                    .background(Color("\(btnColor)"))
                    .clipShape(Circle())
                }
            }
            .padding()
            HStack{
                ForEach(colors, id: \.self) { color in
                    Button {
                        counterStore.changeActiveColor(color: color.label)
                    } label: {
                        let dotHeight = 50.0
                        if(color.label == counterStore.activeCounter.color) {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("\(color.label)FG").opacity(0.5))
                                    .frame(width: dotHeight, height: dotHeight)
                                    .padding()
                                Text("\(counterStore.activeCounter.count)")
                                    .foregroundColor(.white)
                                Circle()
                                    .stroke(Color("\(color.label)").opacity(1), lineWidth: 2)
                                    .frame(width: dotHeight, height: dotHeight)
                            }
                        } else {
                            ZStack {
                                Circle()
                                    .fill(color.color.opacity(0.5))
                                    .frame(width: dotHeight, height: dotHeight)
                                    .padding()
                                Text("\(counterStore.getCountForColor(color: color.label) ?? 0)")
                                    .foregroundColor(Color("\(color.label)FG"))
                                Circle()
                                    .stroke(color.color.opacity(1))
                                    .frame(width: dotHeight, height: dotHeight)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
        //ContentView().preferredColorScheme(.dark)
    }
}
