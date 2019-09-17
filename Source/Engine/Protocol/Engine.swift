//
//  3DEngine.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public protocol G3Engine {
    
    var rootType: G3Root.Type { get }
    var objType: G3Obj.Type { get }
    
    var debugMode: Bool { get set }
    var globalWorldScale: CGFloat { get set }
    
    var roots: [G3Root] { get set }

    init()
    
    func createRoot(frame: CGRect?) -> G3Root
    func addRoot(_ root: G3Root)
    func removeRoot(_ root: G3Root)
    
    func create(_ kind: G3ObjKind) -> G3Obj
    func create(triangle: G3Triangle) -> G3Obj
    func create(line: G3Line) -> G3Obj
    
//    func clone(obj: G3Obj) -> G3Obj
//    func cloneGrid(obj: G3Obj,
//                   xCount: Int,
//                   xRange: ClosedRange<CGFloat>,
//                   yCount: Int,
//                   yRange: ClosedRange<CGFloat>,
//                   zCount: Int,
//                   zRange: ClosedRange<CGFloat>) -> G3Obj

    func debug()
    
}
