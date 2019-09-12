//
//  3DRawEngine.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-09-16.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: Obj

public class G3RawObj: G3Obj {
    
    public let id: UUID
    
    public var name: String?
    
    public var position: G3Vec { get { return G3Vec(xyz: 0.0) } set {} }
    public var rotation: G3Vec { get { return G3Vec(xyz: 0.0) } set {} }
    public var scale: G3Vec { get { return G3Vec(xyz: 0.0) } set {} }
    public var transform: G3Trans {
        get {
            return G3Trans(
                position:G3Vec(xyz: 0.0),
                rotation: G3Vec(xyz: 0.0),
                scale: G3Vec(xyz: 0.0)
            )
        }
        set {}
    }
    
    #if os(iOS)
    public var color: UIColor? = .clear
    #elseif os(macOS)
    public var color: NSColor? = .clear
    #endif
    
    public required init() {
        id = UUID()
    }
    
    public func move(to vec: G3Vec) {}
    public func move(by vec: G3Vec) {}
    
    public func rotate(to vec: G3Vec) {}
    public func rotate(by vec: G3Vec) {}
    
    public func scale(to vec: G3Vec) {}
    public func scale(by vec: G3Vec) {}
    
    public func scale(to val: CGFloat) {}
    public func scale(by val: CGFloat) {}
    
    public func transform(to trans: G3Trans) {}
    public func transform(by trans: G3Trans) {}
    
    public func add(_ obj: G3Obj) {}
    
    public func clone() -> G3Obj {
        self
    }
    
}

// MARK: Root

public class G3RawRoot: G3RawObj, G3Root {
    
    #if os(iOS)
    public var view: UIView
    #elseif os(macOS)
    public var view: NSView
    #endif
    
    #if os(iOS)
    public var snapshot: UIImage {
        return UIImage(named: "")!
    }
    #elseif os(macOS)
    public var snapshot: NSImage {
        return NSImage(named: "")!
    }
    
    #endif
    
    public var worldScale: CGFloat = 1.0
    
    public required override init() {
        #if os(iOS)
        view = UIView()
        #elseif os(macOS)
        view = NSView()
        #endif
        super.init()
    }
    
    public override func add(_ obj: G3Obj) {}
    public func add(_ obj: G3Obj, to parentObj: G3Obj) {}
    
    public func remove(_ obj: G3Obj) {}
    
}

// MARK: Engine

public class G3RawEngine: G3Engine {
    
    public var rootType: G3Root.Type = G3RawRoot.self
    
    public var objType: G3Obj.Type = G3RawObj.self
    
    
    public var debugMode: Bool = false

    public var globalWorldScale: CGFloat = 1.0

    public var roots: [G3Root] = []
    
    public required init() {}
    
    public func debug() {}
    
    public func createRoot(frame: CGRect?) -> G3Root {
        return G3RawRoot()
    }
    
    public func addRoot(_ root: G3Root) {}
    
    public func removeRoot(_ root: G3Root) {}
    
    public func create(_ kind: G3ObjKind) -> G3Obj {
        return G3RawObj()
    }
    public func create(triangle: G3Triangle) -> G3Obj {
        return G3RawObj()
    }
    public func create(line: G3Line) -> G3Obj {
        return G3RawObj()
    }
    
    public func clone(obj: G3Obj) -> G3Obj {
        obj
    }
    
    public func cloneGrid(obj: G3Obj, xCount: Int, xRange: ClosedRange<CGFloat>, yCount: Int, yRange: ClosedRange<CGFloat>, zCount: Int, zRange: ClosedRange<CGFloat>) -> G3Obj {
        obj
    }
    
}
