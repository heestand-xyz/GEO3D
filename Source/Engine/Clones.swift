//
//  Clones.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-17.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation

class Clone {

    let id = UUID()
    
    var object: Any

    let cloneable: Cloneable
    
    init(_ object: Any, from cloneable: Cloneable) {
        self.object = object
        self.cloneable = cloneable
    }

}

protocol Cloneable {

    var outClones: [Clone] { get set }

    func clone() -> Clone

}

protocol Cloner {

    var inClones: [Clone] { get set }

    func add(_ cloneChild: Clone, to cloneParent: Clone)

}
