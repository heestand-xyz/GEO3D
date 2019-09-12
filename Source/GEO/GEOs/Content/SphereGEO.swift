//
//  SphereGEO.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-08-19.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation

public class SphereGEO: GEOContent {
    
    public init() {

        let sphere = GEO3D.engine.create(.sphere)
        
        super.init(obj: sphere)

    }
    
}
