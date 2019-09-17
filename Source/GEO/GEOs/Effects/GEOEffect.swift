//
//  GEOEffect.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation

public class GEOEffect: GEO/*, Cloner*/ {
    
//    var inClones: [Clone] = []
    
    public var inGeos: [GEO] = [] {
        didSet {
//            for geo in oldValue {
//                root.remove(geo.root)
//            }
            print("inGeos >>>")
            print("inGeos", inGeos.map({$0.name}), "to", name)
            for geo in inGeos {
                root.add(geo.root)
            }
            print("inGeos <<<")
        }
    }
    
    override init(name: String) {
        
        super.init(name: name)
        
    }
    
//    func add(_ cloneChild: Clone, to cloneParent: Clone) {
//        let cloneParentRoot = cloneParent.object as! G3Root
//        let cloneChildRoot = cloneChild.object as! G3Root
//        cloneParentRoot.add(cloneChildRoot)
//    }
    
}
