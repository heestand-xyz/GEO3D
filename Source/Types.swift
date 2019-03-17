//
//  3DCoord.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-08-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics

public struct GEO3DVec {
    public var x: CGFloat
    public var y: CGFloat
    public var z: CGFloat
    public init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = CGFloat(x); self.y = CGFloat(y); self.z = CGFloat(z)
    }
    public init(xyz: CGFloat) {
        x = CGFloat(xyz); y = CGFloat(xyz); z = CGFloat(xyz)
    }
    public static let zero = GEO3DVec(x: 0, y: 0, z: 0)
    public static let one = GEO3DVec(x: 1, y: 1, z: 1)
    public static func == (lhs: GEO3DVec, rhs: GEO3DVec) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    public static func != (lhs: GEO3DVec, rhs: GEO3DVec) -> Bool {
        return !(lhs == rhs)
    }
    public static func + (lhs: GEO3DVec, rhs: GEO3DVec) -> GEO3DVec {
        return GEO3DVec(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func - (lhs: GEO3DVec, rhs: GEO3DVec) -> GEO3DVec {
        return GEO3DVec(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func * (lhs: GEO3DVec, rhs: GEO3DVec) -> GEO3DVec {
        return GEO3DVec(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    public static func * (lhs: GEO3DVec, rhs: CGFloat) -> GEO3DVec {
        return GEO3DVec(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: CGFloat, rhs: GEO3DVec) -> GEO3DVec { return rhs * lhs }
    public static func / (lhs: GEO3DVec, rhs: GEO3DVec) -> GEO3DVec {
        return GEO3DVec(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: GEO3DVec, rhs: CGFloat) -> GEO3DVec {
        return GEO3DVec(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func += (lhs: inout GEO3DVec, rhs: GEO3DVec) { lhs = lhs + rhs }
    public static func -= (lhs: inout GEO3DVec, rhs: GEO3DVec) { lhs = lhs - rhs }
    public static func *= (lhs: inout GEO3DVec, rhs: GEO3DVec) { lhs = lhs * rhs }
    public static func *= (lhs: inout GEO3DVec, rhs: CGFloat) { lhs = lhs * rhs }
    public static func /= (lhs: inout GEO3DVec, rhs: GEO3DVec) { lhs = lhs / rhs }
    public mutating func zRotate(by ang: CGFloat, at origin: GEO3DVec = .zero) {
        let tx = (x - origin.x)
        let ty = (y - origin.y)
        var rot = atan2(ty, tx)
        rot += ang
        let rad = sqrt(pow(tx, 2) + pow(ty, 2))
        x = origin.x + cos(rot) * rad
        y = origin.y + sin(rot) * rad
    }
    public mutating func scale(by s: CGFloat, at origin: GEO3DVec = .zero) {
        scale(by: GEO3DVec(xyz: s), at: origin)
    }
    public mutating func scale(by s: GEO3DVec, at origin: GEO3DVec = .zero) {
        let vec = self - origin
        self = origin + vec * s
    }
}

public struct GEO3DUV {
    public var u: CGFloat
    public var v: CGFloat
    public init(u: CGFloat, v: CGFloat) {
        self.u = u; self.v = v
    }
}

infix operator +*=
public struct GEO3DTrans {
    public var position: GEO3DVec
    public var rotation: GEO3DVec
    public var scale: GEO3DVec
    public static let identity = GEO3DTrans(position: GEO3DVec.zero, rotation: GEO3DVec.zero, scale: GEO3DVec.one)
    public static func == (lhs: GEO3DTrans, rhs: GEO3DTrans) -> Bool {
        return lhs.position == rhs.position && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale
    }
    public static func != (lhs: GEO3DTrans, rhs: GEO3DTrans) -> Bool {
        return !(lhs == rhs)
    }
    public static func +*= (lhs: inout GEO3DTrans, rhs: GEO3DTrans) {
        lhs.position *= rhs.scale
        lhs.position += rhs.position
        lhs.rotation += rhs.rotation
        lhs.scale *= rhs.scale
    }
}

public struct UV {
    public var u: CGFloat
    public var v: CGFloat
}

public struct GEO3DVert {
    public let position: GEO3DVec
    public let norm: GEO3DVec
    public let uv: UV
    public init(_ position: GEO3DVec) {
        self.position = position
        norm = GEO3DVec(x: 0, y: 0, z: 1)
        uv = UV(u: 0.5, v: 0.5)
    }
}

public struct GEO3DLine {
    public let vertA: GEO3DVert
    public let vertB: GEO3DVert
    public var verts: [GEO3DVert] {
        return [vertA, vertB]
    }
    public init(_ vertA: GEO3DVert, _ vertB: GEO3DVert) {
        self.vertA = vertA
        self.vertB = vertB
    }
}

public struct GEO3DTriangle {
    public let vertA: GEO3DVert
    public let vertB: GEO3DVert
    public let vertC: GEO3DVert
    public var verts: [GEO3DVert] {
        return [vertA, vertB, vertC]
    }
    public init(_ vertA: GEO3DVert, _ vertB: GEO3DVert, _ vertC: GEO3DVert) {
        self.vertA = vertA
        self.vertB = vertB
        self.vertC = vertC
    }
}

//public struct GEO3DPoly {
//    public let verts: [GEO3DVert]
//    public init(verts: [GEO3DVert]) {
//        self.verts = verts
//    }
//}

//public struct GEO3DQuad {
//}
