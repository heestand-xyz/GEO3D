//
//  Obj.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public enum G3ObjKind {
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

public protocol G3Obj {
    
    var id: UUID { get }
    var name: String? { get set }
    
//    var sourceLinkObj: G3Obj? { get set }
//    var linkObjs: [G3Obj] { get set }
    
    var position: G3Vec { get set }
    var rotation: G3Vec { get set }
    var scale: G3Vec { get set }
    var transform: G3Trans { get set }
    
    #if os(iOS)
    var color: UIColor? { get set }
    #elseif os(macOS)
    var color: NSColor? { get set }
    #endif

    func move(to vec: G3Vec)
    func move(by vec: G3Vec)
    
    func rotate(to vec: G3Vec)
    func rotate(by vec: G3Vec)
    
    func scale(to vec: G3Vec)
    func scale(by vec: G3Vec)
    func scale(to val: CGFloat)
    func scale(by val: CGFloat)
    
    func transform(to trans: G3Trans)
    func transform(by trans: G3Trans)
    
    func add(_ obj: G3Obj)
    
    func clone() -> G3Obj
    
}
