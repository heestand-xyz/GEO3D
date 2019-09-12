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
    
    var root: G3Root
    var obj: G3Obj
    
    public var position: LiveVec = .zero
    public var rotation: LiveVec = .zero
    public var scale: LiveVec = .one

    public var view: UIView {
        root.view
    }
    
    var liveValues: [LiveValue] { return [position, rotation, scale] }
    
    
    init(obj: G3Obj) {
        
        root = GEO3D.engine.rootType.init(frame: nil, ortho: false, debug: true)
        self.obj = obj
        
        root.add(obj)
     
        Live.main.listenToFrames {
            self.checkLive()
        }
        
    }
    
    func newValues() {
        root.position = position.vec
        root.rotation = rotation.vec
        root.scale = scale.vec
    }
    
    func checkLive() {
        for liveValue in liveValues {
            if liveValue.uniformIsNew {
                newValues()
                break
            }
        }
    }
    
}
