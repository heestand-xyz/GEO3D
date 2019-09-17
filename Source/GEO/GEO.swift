//
//  GEO.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-08-19.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Combine
import UIKit

public class GEO: ObservableObject/*, Cloneable*/ {
    
//    var outClones: [Clone] = []
    
    var name: String {
        "geo:" + (root.name ?? "-")
    }
    
    var root: G3Root!
    
    @Published public var position: G3Vec = .zero {
        didSet {
            root.position = position
//            for clone in outClones {
//                var cloneRoot = clone.object as! G3Root
//                cloneRoot.position = position
//            }
        }
    }
    @Published public var rotation: G3Vec = .zero {
        didSet {
            root.rotation = rotation
//            for clone in outClones {
//                var cloneRoot = clone.object as! G3Root
//                cloneRoot.rotation = rotation
//            }
        }
    }
    @Published public var scale: G3Vec = .one {
        didSet {
            root.scale = scale
//            for clone in outClones {
//                var cloneRoot = clone.object as! G3Root
//                cloneRoot.scale = scale
//            }
        }
    }

    public var view: UIView {
        root.view
    }
    
    init(name: String) {
        root = GEO3D.engine.rootType.init(frame: nil, ortho: false, debug: false)
        root.name = "root:\(name)"
    }
    
//    func clone() -> Clone {
//        let clone = Clone(root!, from: self)
//        outClones.append(clone)
//        return clone
//    }
    
}
