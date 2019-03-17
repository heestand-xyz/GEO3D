//
//  3DEngine.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit

public protocol GEO3DObj {
    
    var id: UUID { get }
    
    var pos: GEO3DVec { get set }
    var rot: GEO3DVec { get set }
    var scl: GEO3DVec { get set }
    var trans: GEO3DTrans { get set }
    
    var color: UIColor? { get set }
    
    func position(to GEO3DCoord: GEO3DVec)
    func position(by GEO3DCoord: GEO3DVec)
    
    func rotate(to GEO3DCoord: GEO3DVec)
    func rotate(by GEO3DCoord: GEO3DVec)
    
    func scale(to GEO3DCoord: GEO3DVec)
    func scale(by GEO3DCoord: GEO3DVec)
    func scale(to val: CGFloat)
    func scale(by val: CGFloat)
    
    func transform(to GEO3DTrans: GEO3DTrans)
    func transform(by GEO3DTrans: GEO3DTrans)
    
}

public protocol GEO3DRoot: GEO3DObj {
    
    var id: UUID { get }
    
    var view: UIView { get }
    var snapshot: UIImage { get }
    
    var worldScale: CGFloat { get set }

    func add(_ obj: GEO3DObj)
    func add(_ obj: GEO3DObj, to objParent: GEO3DObj)
    
    func remove(_ obj: GEO3DObj)
    
}

public enum GEO3DObjKind {
    case node
    case plane
    case box
    case sphere
    case pyramid
    case cone
    case cylinder
    case capsule
    case tube
    case torus
}

public protocol GEO3DEngine {
    
    var debugMode: Bool { get set }
    var globalWorldScale: CGFloat { get set }
    
    var roots: [GEO3DRoot] { get set }

    init()
    
    func createRoot(at size: CGSize?) -> GEO3DRoot
    func addRoot(_ objRoot: GEO3DRoot)
    func removeRoot(_ objRoot: GEO3DRoot)
    
    func create(_ GEO3DObjKind: GEO3DObjKind) -> GEO3DObj
    func create(triangle: GEO3DTriangle) -> GEO3DObj
    func create(line: GEO3DLine) -> GEO3DObj

    func debug()
    
}
