//
//  GEO.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-08-19.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Combine
import UIKit
import Live

public class GEO {
    
    let root: G3Root
    let obj: G3Obj
    
//    var position: Binding<G3Vec> = .zero
    
    public var view: UIView {
        root.view
    }
    
    var liveValues: [LiveValue] { return [] }
    
    
    init(obj: G3Obj) {
        
        root = GEO3D.engine.rootType.init(frame: nil, ortho: false, debug: true)
        self.obj = obj
        
        root.add(obj)
        
    }
    
}
