//
//  ScnObj.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import SceneKit

public class G3ScnObj: G3Obj {
   
    public let id = UUID()
    public var name: String?
    
    let node: SCNNode
//    var nodes: [SCNNode] = []

//    public var cloner: G3Obj?
//    public var clones: [G3Obj] = []
    
//    public var subClones: [G3Obj] = []
//    var cloneCloned: (() -> ())?

//    public var sourceLinkObj: G3Obj?
//    public var linkObjs: [G3Obj] = []
//    public var linkNodes: [SCNNode] = []

    public var position: G3Vec {
        get { return node.position.vec }
        set {
            print("position", name ?? "-")//, "with clones", clones.map({$0.name ?? "-"}))//, "with sub clones", subClones.map({$0.name ?? "-"}))
            node.position = newValue.scnVec
//            for node in nodes {
//                node.position = newValue.scnVec
//            }
//            for obj in clones {
//                var obj = obj
//                obj.position = newValue
//            }
//            for obj in subClones {
//                var obj = obj
//                obj.position = newValue
//            }
//            for subNode in linkNodes {
//                subNode.position = newValue.scnVec
//            }
        }
    }
    public var rotation: G3Vec {
        get { return node.eulerAngles.vec }
        set {
            print("rotation", name ?? "-")//, "with clones", clones.map({$0.name ?? "-"}))//, "with sub clones", subClones.map({$0.name ?? "-"}))
            node.eulerAngles = newValue.scnVec
//            for node in nodes {
//                node.eulerAngles = newValue.scnVec
//            }
//            for obj in clones {
//                var obj = obj
//                obj.rotation = newValue
//            }
//            for obj in subClones {
//                var obj = obj
//                obj.rotation = newValue
//            }
//            for subNode in linkNodes {
//                subNode.eulerAngles = newValue.scnVec
//            }
        }
    }
    public var scale: G3Vec {
        get { return node.scale.vec }
        set {
            print("scale", name ?? "-")//, "with clones", clones.map({$0.name ?? "-"}))//, "with sub clones", subClones.map({$0.name ?? "-"}))
            node.scale = newValue.scnVec
//            for node in nodes {
//                node.scale = newValue.scnVec
//            }
//            for obj in clones {
//                var obj = obj
//                obj.scale = newValue
//            }
//            for obj in subClones {
//                var obj = obj
//                obj.scale = newValue
//            }
//            for subNode in linkNodes {
//                subNode.scale = newValue.scnVec
//            }
        }
        
    }
    public var transform: G3Trans {
        get { return G3Trans(position: position, rotation: rotation, scale: scale) }
        set { position = newValue.position; rotation = newValue.rotation; scale = newValue.scale }
    }
    
    #if os(iOS)
    public var color: UIColor? {
        get { return node.geometry?.firstMaterial?.diffuse.contents as? UIColor }
        set { node.geometry?.firstMaterial?.diffuse.contents = newValue }
    }
    #elseif os(macOS)
    public var color: NSColor? {
        get { return node.geometry?.firstMaterial?.diffuse.contents as? NSColor }
        set { node.geometry?.firstMaterial?.diffuse.contents = newValue }
    }
    #endif
    
    init(geometry: SCNGeometry) {
        node = SCNNode(geometry: geometry)
    }
    init(node: SCNNode) {
        self.node = node
    }
    
    public func move(to vec: G3Vec) { position = vec }
    public func move(by vec: G3Vec) { position += vec }
    
    public func rotate(to vec: G3Vec) { rotation = vec }
    public func rotate(by vec: G3Vec) { rotation += vec }
    
    public func scale(to vec: G3Vec) { scale = vec }
    public func scale(by vec: G3Vec) { scale *= vec }
    public func scale(to val: CGFloat) { scale = G3Vec(x: val, y: val, z: val) }
    public func scale(by val: CGFloat) { scale *= G3Vec(x: val, y: val, z: val) }
    
    public func transform(to trans: G3Trans) { transform = trans }
    public func transform(by trans: G3Trans) { transform +*= trans }
    
    public func add(_ obj: G3Obj) {
        print("add", obj.name ?? "-", "to", name ?? "-")
        let scnGeo3DObj = obj as! G3ScnObj
//        let node = scnGeo3DObj.node.clone()
//        scnGeo3DObj.nodes.append(node)
        node.addChildNode(scnGeo3DObj.node)
    }
    
//    public func clone() -> G3Obj {
//        print("clone", name ?? "-")
//        let node = self.node.clone()
////        let subNode = SCNNode()
////        subNode.addChildNode(newNode)
//        let obj = G3ScnObj(node: node/*subNode*/)
//        obj.cloner = self
////        subClones = obj.clones
////        cloneCloned...
//        obj.name = "clone:\(self.name ?? "")"
////        link(newObj, with: newNode)
//        clones.append(obj)
//        return obj
//    }
    
//    func link(_ newObj: G3ScnObj, with newNode: SCNNode) {
//        print("link", name ?? "-", "->", newObj.name ?? "-")
//        func connect(obj: G3ScnObj) {
//            obj.linkObjs.append(newObj)
//            obj.linkNodes.append(newNode)
//        }
//        func subLink(obj: G3ScnObj) {
//            if let linkObj = obj.sourceLinkObj as! G3ScnObj? {
//                print("subLink linkObj:", obj.name ?? "-")
//                connect(obj: linkObj)
//                subLink(obj: linkObj)
//            }
//        }
//        connect(obj: self)
//        subLink(obj: self)
//        newObj.sourceLinkObj = self
//    }
    
}
