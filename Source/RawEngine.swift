//
//  3DRawEngine.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-09-16.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit

// MARK: Obj

class GEO3DRawObj: GEO3DObj {
    
    let id: UUID
    
    var pos: GEO3DVec { get { return GEO3DVec(xyz: 0.0) } set {} }
    var rot: GEO3DVec { get { return GEO3DVec(xyz: 0.0) } set {} }
    var scl: GEO3DVec { get { return GEO3DVec(xyz: 0.0) } set {} }
    var trans: GEO3DTrans {
        get {
            return GEO3DTrans(
                pos:GEO3DVec(xyz: 0.0),
                rot: GEO3DVec(xyz: 0.0),
                scl: GEO3DVec(xyz: 0.0)
            )
        }
        set {}
    }
    
    var color: UIColor? = .clear
    
    init() {
        id = UUID()
    }
    
    func position(to GEO3DCoord: GEO3DVec) {}
    func position(by GEO3DCoord: GEO3DVec) {}
    
    func rotate(to GEO3DCoord: GEO3DVec) {}
    func rotate(by GEO3DCoord: GEO3DVec) {}
    
    func scale(to GEO3DCoord: GEO3DVec) {}
    func scale(by GEO3DCoord: GEO3DVec) {}
    
    func scale(to val: CGFloat) {}
    func scale(by val: CGFloat) {}
    
    func transform(to GEO3DTrans: GEO3DTrans) {}
    func transform(by GEO3DTrans: GEO3DTrans) {}
    
}

// MARK: Root

class GEO3DRawRoot: GEO3DRawObj, GEO3DRoot {
    
    var view: UIView
    
    var snapshot: UIImage {
        return UIImage(named: "")!
    }
    
    var worldScale: CGFloat = 1.0
    
    override init() {
        view = UIView()
        super.init()
    }
    
    func add(_ obj: GEO3DObj) {}
    func add(_ obj: GEO3DObj, to objParent: GEO3DObj) {}
    
    func remove(_ obj: GEO3DObj) {}
    
}

// MARK: Engine

class GEO3DRawEngine: GEO3DEngine {  
    
    var debugMode: Bool = false

    var globalWorldScale: CGFloat = 1.0

    var roots: [GEO3DRoot] = []
    
    required init() {}
    
    func debug() {}
    
    func createRoot(at size: CGSize?) -> GEO3DRoot {
        return GEO3DRawRoot()
    }
    
    func addRoot(_ objRoot: GEO3DRoot) {}
    
    func removeRoot(_ objRoot: GEO3DRoot) {}
    
    func create(_ GEO3DObjKind: GEO3DObjKind) -> GEO3DObj {
        return GEO3DRawObj()
    }
    func create(triangle: GEO3DTriangle) -> GEO3DObj {
        return GEO3DRawObj()
    }
    func create(line: GEO3DLine) -> GEO3DObj {
        return GEO3DRawObj()
    }
    
}
