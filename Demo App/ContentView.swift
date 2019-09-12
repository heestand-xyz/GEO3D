//
//  ContentView.swift
//  Demo App
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import SwiftUI
import GEO3D

struct ContentView: View {
    @ObservedObject var sphere = SphereGEO()
    @ObservedObject var box = BoxGEO()
    @ObservedObject var node = NodeGEO()
    var body: some View {
        VStack {
            GEORepView(geo: sphere)
            Text("\(sphere.position.y)")
            Slider(value: $sphere.position.y)
            GEORepView(geo: box)
            Text("\(box.position.y)")
            Slider(value: $box.position.y)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
