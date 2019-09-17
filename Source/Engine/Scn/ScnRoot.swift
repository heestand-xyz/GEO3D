//
//  ScnRoot.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import SceneKit

public class G3ScnRoot: G3ScnObj, G3Root {
    
    #if os(iOS)
    public var worldScale: CGFloat {
        get { return scn.rootNode.scale.vec.x }
        set { scn.rootNode.scale = SCNVector3(x: Float(newValue), y: Float(newValue), z: Float(newValue)) }
    }
    #elseif os(macOS)
    public var worldScale: CGFloat {
        get { return scn.rootNode.scale.vec.x }
        set { scn.rootNode.scale = SCNVector3(x: newValue, y: newValue, z: newValue) }
    }
    #endif
    
//    public var objs: [G3Obj] = []

    #if os(iOS)
    public let view: UIView
    #elseif os(macOS)
    public let view: NSView
    #endif
    let scn = SCNScene()
    
    #if os(iOS)
    public var snapshot: UIImage {
        return (view as! SCNView).snapshot()
    }
    #elseif os(macOS)
    public var snapshot: NSImage {
        return (view as! SCNView).snapshot()
    }
    #endif
    
//    let cam: SCNCamera
//    let camNode: SCNNode
    
    public required init(frame: CGRect? = nil, ortho: Bool = false, debug: Bool = false) {
        
        let scnView: SCNView
        if let frame = frame {
            scnView = SCNView(frame: frame)
        } else {
            scnView = SCNView()
        }
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
//        scnView.allowsCameraControl = true
        scnView.scene = scn
        if debug {
            scnView.showsStatistics = true
            if #available(iOS 11.0, *) { scnView.debugOptions.insert(.renderAsWireframe) }
//            scnView.debugOptions.insert(.showWireframe)
//            scnView.debugOptions.insert(.showBoundingBoxes)
//            glLineWidth(20)
        }
        view = scnView

        
//        cam = SCNCamera()
//        cam.automaticallyAdjustsZRange = true
//        if #available(iOS 11.0, *) {
//            cam.fieldOfView = 53.1301023542
//        }
//        if ortho {
//            cam.usesOrthographicProjection = true
////            cam.orthographicScale = 1
//        }
//        camNode = SCNNode()
//        camNode.move = SCNVector3(x: 0, y: 0, z: 1)
//        camNode.camera = cam
//        scn.rootNode.addChildNode(camNode)
        
        super.init(node: scn.rootNode)
        
        scn.rootNode.addChildNode(node)
        
    }
    
    public override func add(_ obj: G3Obj) {
        let scnGeo3DObj = obj as! G3ScnObj
//        let node = scnGeo3DObj.node.clone()
//        scnGeo3DObj.nodes.append(node)
        scn.rootNode.addChildNode(scnGeo3DObj.node)
//        objs.append(obj)
    }
    
//    public func add(_ obj: G3Obj, to parentObj: G3Obj) {
//        let scnGeo3DObj = obj as! G3ScnObj
//        let scnGeo3DObjParent = parentObj as! G3ScnObj
//        scnGeo3DObjParent.node.addChildNode(scnGeo3DObj.node)
//    }
    
    public func remove(_ obj: G3Obj) {
        let scnGeo3DObj = obj as! G3ScnObj
        scnGeo3DObj.node.removeFromParentNode()
    }
    
//    public func clone() -> G3Root {
//        let root = G3ScnRoot()
//        for obj in objs {
//            root.add(obj)
//        }
//        clones.append(root)
//        return root
//    }
    
}
