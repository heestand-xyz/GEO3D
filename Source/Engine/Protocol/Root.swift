//
//  Root.swift
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

public protocol G3Root: G3Obj {
    
    var id: UUID { get }
    
//    var objs: [G3Obj] { get set }

    #if os(iOS)
    var view: UIView { get }
    var snapshot: UIImage { get }
    #elseif os(macOS)
    var view: NSView { get }
    var snapshot: NSImage { get }
    #endif
    
    var worldScale: CGFloat { get set }

    init(frame: CGRect?, ortho: Bool, debug: Bool)

//    func add(_ obj: G3Obj, to parentObj: G3Obj)
    
    func remove(_ obj: G3Obj)
    
}
