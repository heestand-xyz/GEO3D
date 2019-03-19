//
//  3DScnEngine.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import SceneKit

// MARK: Obj

extension GEO3DVec {
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

private extension SCNVector3 {
    var vec: GEO3DVec { get { return GEO3DVec(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z)) } }
}

public class GEO3DScnObj: GEO3DObj {
    
    public let id = UUID()
    public var name: String?
    
    let node: SCNNode
    
    public var sourceLinkObj: GEO3DObj?
    public var linkObjs: [GEO3DObj] = []
    public var linkNodes: [SCNNode] = []

    public var position: GEO3DVec {
        get { return node.position.vec }
        set {
            node.position = newValue.scnVec
            for subNode in linkNodes {
                subNode.position = newValue.scnVec
            }
        }
    }
    public var rotation: GEO3DVec {
        get {
            return node.eulerAngles.vec }
        set {
            node.eulerAngles = newValue.scnVec
            for subNode in linkNodes {
                subNode.eulerAngles = newValue.scnVec
            }
        }
    }
    public var scale: GEO3DVec {
        get {
            return node.scale.vec }
        set {
            node.scale = newValue.scnVec
            for subNode in linkNodes {
                subNode.scale = newValue.scnVec
            }
        }
        
    }
    public var trans: GEO3DTrans {
        get { return GEO3DTrans(position: position, rotation: rotation, scale: scale) }
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
    
    public func transform(to GEO3DTrans: GEO3DTrans) { trans = GEO3DTrans }
    public func transform(by GEO3DTrans: GEO3DTrans) { trans +*= GEO3DTrans }
    
    public func move(to GEO3DCoord: GEO3DVec) { position = GEO3DCoord }
    public func move(by GEO3DCoord: GEO3DVec) { position += GEO3DCoord }
    
    public func rotate(to GEO3DCoord: GEO3DVec) { rotation = GEO3DCoord }
    public func rotate(by GEO3DCoord: GEO3DVec) { rotation += GEO3DCoord }
    
    public func scale(to GEO3DCoord: GEO3DVec) { scale = GEO3DCoord }
    public func scale(by GEO3DCoord: GEO3DVec) { scale *= GEO3DCoord }
    public func scale(to val: CGFloat) { scale = GEO3DVec(x: val, y: val, z: val) }
    public func scale(by val: CGFloat) { scale *= GEO3DVec(x: val, y: val, z: val) }
    
    public func add(_ obj: GEO3DObj) {
        print("add", name ?? "-", "->", obj.name ?? "-")
        let scnGeo3DObj = obj as! GEO3DScnObj
        node.addChildNode(scnGeo3DObj.node)
    }
    
    public func clone() -> GEO3DObj {
        print("clone", name ?? "-")
        let newNode = node.clone()
        let subNode = SCNNode()
        subNode.addChildNode(newNode)
        let newObj = GEO3DScnObj(node: subNode)
        link(newObj, with: newNode)
        return newObj
    }
    
    func link(_ newObj: GEO3DScnObj, with newNode: SCNNode) {
        print("link", name ?? "-", "->", newObj.name ?? "-")
        func connect(obj: GEO3DScnObj) {
            obj.linkObjs.append(newObj)
            obj.linkNodes.append(newNode)
        }
        func subLink(obj: GEO3DScnObj) {
            if let linkObj = obj.sourceLinkObj as! GEO3DScnObj? {
                connect(obj: linkObj)
                subLink(obj: linkObj)
            }
        }
        connect(obj: self)
        subLink(obj: self)
        newObj.sourceLinkObj = self
    }
    
}

// MARK: Root

public class GEO3DScnRoot: GEO3DScnObj, GEO3DRoot {
    
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

    public init(frame: CGRect? = nil, ortho: Bool = false, debug: Bool = false) {
        
        let scnView: SCNView
        if let frame = frame {
            scnView = SCNView(frame: frame)
        } else {
            scnView = SCNView()
        }
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
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
        
    }
    
    public override func add(_ obj: GEO3DObj) {
        let scnGeo3DObj = obj as! GEO3DScnObj
        scn.rootNode.addChildNode(scnGeo3DObj.node)
    }
    
    public func add(_ obj: GEO3DObj, to objParent: GEO3DObj) {
        let scnGeo3DObj = obj as! GEO3DScnObj
        let scnGeo3DObjParent = objParent as! GEO3DScnObj
        scnGeo3DObjParent.node.addChildNode(scnGeo3DObj.node)
    }
    
    public func remove(_ obj: GEO3DObj) {
        let scnGeo3DObj = obj as! GEO3DScnObj
        scnGeo3DObj.node.removeFromParentNode()
    }
    
}

// MARK: Engine

public class GEO3DScnEngine: GEO3DEngine {
    
    public var debugMode: Bool = false
    public func debug() { debugMode = true }
        
    public var roots: [GEO3DRoot] = []
    
    public var globalWorldScale: CGFloat = 1 {
        didSet {
            for root in roots as! [GEO3DScnRoot] {
                root.worldScale = globalWorldScale
            }
        }
    }
    
    public required init() {}
    
    public func createRoot(frame: CGRect? = nil) -> GEO3DRoot {
        return GEO3DScnRoot(frame: frame, debug: debugMode)
    }
    
    public func create(_ GEO3DObjKind: GEO3DObjKind) -> GEO3DObj {
        
        let scnGeoPrim: GEO3DScnObj
        switch GEO3DObjKind {
        case .node:
            scnGeoPrim = GEO3DScnObj(node: SCNNode())
        case .plane:
            scnGeoPrim = GEO3DScnObj(geometry: SCNPlane(width: 1, height: 1))
        case .box:
            scnGeoPrim = GEO3DScnObj(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1))
        case .sphere:
            scnGeoPrim = GEO3DScnObj(geometry: SCNSphere(radius: 0.5)) // .isGeodesic
        case .pyramid:
            scnGeoPrim = GEO3DScnObj(geometry: SCNPyramid(width: 1.5, height: 1, length: 1.5)) // 146.5 230.4
        case .cone:
            scnGeoPrim = GEO3DScnObj(geometry: SCNCone(topRadius: 0, bottomRadius: 1, height: 1))
        case .cylinder:
            scnGeoPrim = GEO3DScnObj(geometry: SCNCylinder(radius: 1, height: 1))
        case .capsule:
            scnGeoPrim = GEO3DScnObj(geometry: SCNCapsule(capRadius: 0.5, height: 1))
        case .tube:
            scnGeoPrim = GEO3DScnObj(geometry: SCNTube(innerRadius: 0.5, outerRadius: 1, height: 1))
        case .torus:
            scnGeoPrim = GEO3DScnObj(geometry: SCNTorus(ringRadius: 1, pipeRadius: 0.5))
        }
                
        return scnGeoPrim
        
    }
    
    public func create(triangle: GEO3DTriangle) -> GEO3DObj {
        
//        var positionArr: [GEO3DVec] = []
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
        
        let obj = GEO3DScnObj(geometry: geo)
        
        return obj
    }
    
    public func create(line: GEO3DLine) -> GEO3DObj {

//        var positionArr: [GEO3DVec] = []
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

        let obj = GEO3DScnObj(geometry: geo)
        
        return obj
    }
    
    public func createSources(from verts: [GEO3DVert]) -> [SCNGeometrySource] {
        
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
    
    public func clone(obj: GEO3DObj) -> GEO3DObj {
        return (obj as! GEO3DScnObj).clone()
    }
    
    public func cloneGrid(obj: GEO3DObj,
                          xCount: Int = 5,
                          xRange: ClosedRange<CGFloat> = -0.5...0.5,
                          yCount: Int = 5,
                          yRange: ClosedRange<CGFloat> = -0.5...0.5,
                          zCount: Int = 5,
                          zRange: ClosedRange<CGFloat> = -0.5...0.5) -> GEO3DObj {
        var node = create(.node)
        node.name = "Clone Grid"
        for x in 0..<xCount {
            let xf = CGFloat(x) / CGFloat(xCount - 1)
            let xp = xRange.lowerBound + xf * (xRange.upperBound - xRange.lowerBound)
            for y in 0..<yCount {
                let yf = CGFloat(y) / CGFloat(yCount - 1)
                let yp = yRange.lowerBound + yf * (yRange.upperBound - yRange.lowerBound)
                for z in 0..<zCount {
                    let zf = CGFloat(z) / CGFloat(zCount - 1)
                    let zp = zRange.lowerBound + zf * (zRange.upperBound - zRange.lowerBound)
                    var objClone = obj.clone()
                    objClone.position = GEO3DVec(x: xp, y: yp, z: zp)
                    node.add(objClone)
                }
            }
        }
        return node
    }
    
    public func addRoot(_ root: GEO3DRoot) {
        var root = root
        root.worldScale = globalWorldScale
        roots.append(root)
    }
    
    public func removeRoot(_ root: GEO3DRoot) {
        for (i, i_root) in roots.enumerated() {
            if i_root.id == root.id {
                roots.remove(at: i)
                break
            }
        }
    }
    
}
