//
//  GEO.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-08-19.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Combine
import UIKit

public class GEO: ObservableObject {
    
    var root: G3Root
    
    @Published public var position: G3Vec = .zero { didSet { root.position = position } }
    @Published public var rotation: G3Vec = .zero { didSet { root.rotation = rotation } }
    @Published public var scale: G3Vec = .one { didSet { root.scale = scale } }

    public var view: UIView {
        root.view
    }
    
    init() {
        
        root = GEO3D.engine.rootType.init(frame: nil, ortho: false, debug: true)
     
    }
    
}
