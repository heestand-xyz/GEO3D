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
//    @EnvironmentObject var geo3d: GEO3D<G3ScnEngine>
    var body: some View {
        GEORepView(geo: SphereGEO())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.environmentObject(GEO3D<G3ScnEngine>())
    }
}
