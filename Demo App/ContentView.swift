//
//  ContentView.swift
//  Demo App
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import SwiftUI
import GEO3D

class Main: ObservableObject {
    @Published var box = BoxGEO()
    @Published var node1 = NodeGEO(as: "1")
    @Published var node2 = NodeGEO(as: "2")
    init() {
        node1.inGeos.append(box)
        node2.inGeos.append(node1)
    }
}

struct ContentView: View {
    @ObservedObject var main = Main()
    var body: some View {
        VStack {
            
            VStack {
                GEORepView(geo: main.box)
                Text("\(main.box.scale.y)")
                Slider(value: $main.box.scale.y)
            }
            
            Divider()
            
            VStack {
                GEORepView(geo: main.node1)
                Text("\(main.node1.position.y)")
                Slider(value: $main.node1.position.y)
            }
            
            Divider()
            
            VStack {
                GEORepView(geo: main.node2)
                Text("\(main.node2.position.x)")
                Slider(value: $main.node2.position.x)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
