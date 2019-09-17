//
//  3DScnEngine.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import SceneKit

extension G3Vec {
    var scnVec: SCNVector3 {
        get {
            #if os(iOS)
            return SCNVector3(Float(x), Float(y), Float(z))
            #elseif os(macOS)
            return SCNVector3(CGFloat(x), CGFloat(y), CGFloat(z))
            #endif
        }
    }
}

extension SCNVector3 {
    var vec: G3Vec { get { return G3Vec(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z)) } }
}

public class G3ScnEngine: G3Engine {
    
    public var rootType: G3Root.Type = G3ScnRoot.self
     
    public var objType: G3Obj.Type = G3ScnObj.self
    
    
    public static let shared = G3ScnEngine()
    
    public var debugMode: Bool = false
    public func debug() { debugMode = true }
        
    public var roots: [G3Root] = []
    
    public var globalWorldScale: CGFloat = 1 {
        didSet {
            for root in roots as! [G3ScnRoot] {
                root.worldScale = globalWorldScale
            }
        }
    }
    
    public required init() {}
    
    public func createRoot(frame: CGRect? = nil) -> G3Root {
        return G3ScnRoot(frame: frame, debug: debugMode)
    }
    
    public func create(_ kind: G3ObjKind) -> G3Obj {
        
        let scnGeoPrim: G3ScnObj
        switch kind {
        case .node:
            scnGeoPrim = G3ScnObj(node: SCNNode())
            scnGeoPrim.name = "node"
        case .plane:
            scnGeoPrim = G3ScnObj(geometry: SCNPlane(width: 1, height: 1))
            scnGeoPrim.name = "plane"
        case .box:
            scnGeoPrim = G3ScnObj(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1))
            scnGeoPrim.name = "box"
        case .sphere:
            scnGeoPrim = G3ScnObj(geometry: SCNSphere(radius: 0.5)) // .isGeodesic
            scnGeoPrim.name = "sphere"
        case .pyramid:
            scnGeoPrim = G3ScnObj(geometry: SCNPyramid(width: 1.5, height: 1, length: 1.5)) // 146.5 230.4
            scnGeoPrim.name = "pyramid"
        case .cone:
            scnGeoPrim = G3ScnObj(geometry: SCNCone(topRadius: 0, bottomRadius: 1, height: 1))
            scnGeoPrim.name = "cone"
        case .cylinder:
            scnGeoPrim = G3ScnObj(geometry: SCNCylinder(radius: 1, height: 1))
            scnGeoPrim.name = "cylinder"
        case .capsule:
            scnGeoPrim = G3ScnObj(geometry: SCNCapsule(capRadius: 0.5, height: 1))
            scnGeoPrim.name = "capsule"
        case .tube:
            scnGeoPrim = G3ScnObj(geometry: SCNTube(innerRadius: 0.5, outerRadius: 1, height: 1))
            scnGeoPrim.name = "tube"
        case .torus:
            scnGeoPrim = G3ScnObj(geometry: SCNTorus(ringRadius: 1, pipeRadius: 0.5))
            scnGeoPrim.name = "torus"
        }
                
        return scnGeoPrim
        
    }
    
    public func create(triangle: G3Triangle) -> G3Obj {
        
//        var positionArr: [G3Vec] = []
//        var iArr: [Int] = []
//        var i = 0
//        for poly in polys {
//            for vert in poly.verts {
//                positionArr.append(vert.position)
//                iArr.append(i)
//                i += 1
//            }
//        }
        
        print(">>>")
        
        let iArr = triangle.verts.enumerated().map { i, _ -> Int in return i }
//        let element = SCNGeometryElement(indices: iArr, primitiveType: .triangles)
        let dat = Data(bytes: iArr, count: MemoryLayout<Int>.size * iArr.count)
        let element = SCNGeometryElement(data: dat, primitiveType: .triangles, primitiveCount: 1, bytesPerIndex: MemoryLayout<Int>.size)
        
//        let positionArr = triangle.verts.map { vert -> SCNVector3 in return vert.position.scnVec }
//        let normArr = triangle.verts.map { vert -> SCNVector3 in return vert.norm.scnVec }
//        let sourceVerts = SCNGeometrySource(vertices: positionArr)
//        let sourceNorms = SCNGeometrySource(normals: normArr)
//        let sources = [sourceVerts, sourceNorms]
        let sources = createSources(from: triangle.verts)

        let geo = SCNGeometry(sources: sources, elements: [element])
        
        let obj = G3ScnObj(geometry: geo)
        
        return obj
    }
    
    public func create(line: G3Line) -> G3Obj {

//        var positionArr: [G3Vec] = []
//        var iArr: [Int] = []
//        var i = 0
//        for poly in polys {
//            for vert in poly.verts {
//                positionArr.append(vert.position)
//                iArr.append(i)
//                i += 1
//            }
//        }

//        let vertArr = line.verts.map { vert -> SCNVector3 in return vert.position.scnVec }
//        let normArr = line.verts.map { vert -> SCNVector3 in return vert.norm.scnVec }
//        let iArr = [0, 1]
//
//        let sourceVerts = SCNGeometrySource(vertices: vertArr)
//        let sourceNorms = SCNGeometrySource(normals: normArr)
//        let element = SCNGeometryElement(indices: iArr, primitiveType: .line)
//
//        let geo = SCNGeometry(sources: [sourceVerts, sourceNorms], elements: [element])

        let pln = SCNPlane(width: 0.5, height: 2)
        pln.heightSegmentCount = 4
        let cpy = pln.copy() as! SCNGeometry
        print("A", cpy.sources[0])
        print("B", cpy.sources[1])
        print("C", cpy.elements[0])
        let geo = SCNGeometry(sources: [cpy.sources.first!, cpy.sources[1]], elements: [cpy.elements.first!])

        let obj = G3ScnObj(geometry: geo)
        
        return obj
    }
    
    public func createSources(from verts: [G3Vert]) -> [SCNGeometrySource] {
        
        struct FloatVert {
            let px, py, pz: Float
            let nx, ny, nz: Float
            let u, v: Float
        }
        let floatVerts = verts.map { vert -> FloatVert in
            return FloatVert(
                px: Float(vert.position.x),
                py: Float(vert.position.y),
                pz: Float(vert.position.z),
                nx: Float(vert.norm.x),
                ny: Float(vert.norm.y),
                nz: Float(vert.norm.z),
                u: Float(vert.uv.u),
                v: Float(vert.uv.v)
            )
        }

        let vertSize = MemoryLayout<FloatVert>.size
        let valSize = MemoryLayout<Float>.size

        let data = Data(bytes: floatVerts, count: floatVerts.count)
        let vertexSource = SCNGeometrySource(data: data, semantic: .vertex, vectorCount: floatVerts.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: valSize, dataOffset: 0, dataStride: vertSize)
        let normalSource = SCNGeometrySource(data: data, semantic: .normal, vectorCount: floatVerts.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: valSize, dataOffset: valSize * 3, dataStride: vertSize)
        let tcoordSource = SCNGeometrySource(data: data, semantic: .texcoord, vectorCount: floatVerts.count, usesFloatComponents: true, componentsPerVector: 2, bytesPerComponent: valSize, dataOffset: valSize * 6, dataStride: vertSize)
        
        return [vertexSource, normalSource, tcoordSource]

    }
    
//    public func clone(obj: G3Obj) -> G3Obj {
//        return (obj as! G3ScnObj).clone()
//    }
    
//    public func cloneGrid(obj: G3Obj,
//                          xCount: Int = 5,
//                          xRange: ClosedRange<CGFloat> = -0.5...0.5,
//                          yCount: Int = 5,
//                          yRange: ClosedRange<CGFloat> = -0.5...0.5,
//                          zCount: Int = 5,
//                          zRange: ClosedRange<CGFloat> = -0.5...0.5) -> G3Obj {
//        var node = create(.node)
//        node.name = "Clone Grid"
//        for x in 0..<xCount {
//            let xf = CGFloat(x) / CGFloat(xCount - 1)
//            let xp = xRange.lowerBound + xf * (xRange.upperBound - xRange.lowerBound)
//            for y in 0..<yCount {
//                let yf = CGFloat(y) / CGFloat(yCount - 1)
//                let yp = yRange.lowerBound + yf * (yRange.upperBound - yRange.lowerBound)
//                for z in 0..<zCount {
//                    let zf = CGFloat(z) / CGFloat(zCount - 1)
//                    let zp = zRange.lowerBound + zf * (zRange.upperBound - zRange.lowerBound)
//                    var objClone = obj.clone()
//                    objClone.position = G3Vec(x: xp, y: yp, z: zp)
//                    node.add(objClone)
//                }
//            }
//        }
//        return node
//    }
    
    public func addRoot(_ root: G3Root) {
        var root = root
        root.worldScale = globalWorldScale
        roots.append(root)
    }
    
    public func removeRoot(_ root: G3Root) {
        for (i, i_root) in roots.enumerated() {
            if i_root.id == root.id {
                roots.remove(at: i)
                break
            }
        }
    }
    
}
