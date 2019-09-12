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
//    @State var sphere = SphereGEO()
//    @State var box = BoxGEO()
//    @State var node = NodeGEO()
    var body: some View {
        VStack {
            GEORepView(geo: sphere)
//            Slider(value: sphere.scale.y.bond)
            GEORepView(geo: box)
            Text("\(box.y)")
            Slider(value: $box.y)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
