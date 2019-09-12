//
//  3DCoord.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-08-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import SwiftUI

public struct G3Vec {
    public var x: CGFloat
    public var y: CGFloat
    public var z: CGFloat
    public init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = CGFloat(x); self.y = CGFloat(y); self.z = CGFloat(z)
    }
    public init(xyz: CGFloat) {
        x = CGFloat(xyz); y = CGFloat(xyz); z = CGFloat(xyz)
    }
    public static let zero = G3Vec(x: 0, y: 0, z: 0)
    public static let one = G3Vec(x: 1, y: 1, z: 1)
    public static func == (lhs: G3Vec, rhs: G3Vec) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    public static func != (lhs: G3Vec, rhs: G3Vec) -> Bool {
        return !(lhs == rhs)
    }
    public static func + (lhs: G3Vec, rhs: G3Vec) -> G3Vec {
        return G3Vec(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func - (lhs: G3Vec, rhs: G3Vec) -> G3Vec {
        return G3Vec(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func * (lhs: G3Vec, rhs: G3Vec) -> G3Vec {
        return G3Vec(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    public static func * (lhs: G3Vec, rhs: CGFloat) -> G3Vec {
        return G3Vec(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: CGFloat, rhs: G3Vec) -> G3Vec { return rhs * lhs }
    public static func / (lhs: G3Vec, rhs: G3Vec) -> G3Vec {
        return G3Vec(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: G3Vec, rhs: CGFloat) -> G3Vec {
        return G3Vec(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func += (lhs: inout G3Vec, rhs: G3Vec) { lhs = lhs + rhs }
    public static func -= (lhs: inout G3Vec, rhs: G3Vec) { lhs = lhs - rhs }
    public static func *= (lhs: inout G3Vec, rhs: G3Vec) { lhs = lhs * rhs }
    public static func *= (lhs: inout G3Vec, rhs: CGFloat) { lhs = lhs * rhs }
    public static func /= (lhs: inout G3Vec, rhs: G3Vec) { lhs = lhs / rhs }
    public mutating func zRotate(by ang: CGFloat, at origin: G3Vec = .zero) {
        let tx = (x - origin.x)
        let ty = (y - origin.y)
        var rot = atan2(ty, tx)
        rot += ang
        let rad = sqrt(pow(tx, 2) + pow(ty, 2))
        x = origin.x + cos(rot) * rad
        y = origin.y + sin(rot) * rad
    }
    public mutating func scale(by s: CGFloat, at origin: G3Vec = .zero) {
        scale(by: G3Vec(xyz: s), at: origin)
    }
    public mutating func scale(by s: G3Vec, at origin: G3Vec = .zero) {
        let vec = self - origin
        self = origin + vec * s
    }
}

public struct G3UV {
    public var u: CGFloat
    public var v: CGFloat
    public init(u: CGFloat, v: CGFloat) {
        self.u = u; self.v = v
    }
}

infix operator +*=
public struct G3Trans {
    public var position: G3Vec
    public var rotation: G3Vec
    public var scale: G3Vec
    public static let identity = G3Trans(position: G3Vec.zero, rotation: G3Vec.zero, scale: G3Vec.one)
    public static func == (lhs: G3Trans, rhs: G3Trans) -> Bool {
        return lhs.position == rhs.position && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale
    }
    public static func != (lhs: G3Trans, rhs: G3Trans) -> Bool {
        return !(lhs == rhs)
    }
    public static func +*= (lhs: inout G3Trans, rhs: G3Trans) {
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

public struct G3Vert {
    public let position: G3Vec
    public let norm: G3Vec
    public let uv: UV
    public init(_ position: G3Vec) {
        self.position = position
        norm = G3Vec(x: 0, y: 0, z: 1)
        uv = UV(u: 0.5, v: 0.5)
    }
}

public struct G3Line {
    public let vertA: G3Vert
    public let vertB: G3Vert
    public var verts: [G3Vert] {
        return [vertA, vertB]
    }
    public init(_ vertA: G3Vert, _ vertB: G3Vert) {
        self.vertA = vertA
        self.vertB = vertB
    }
}

public struct G3Triangle {
    public let vertA: G3Vert
    public let vertB: G3Vert
    public let vertC: G3Vert
    public var verts: [G3Vert] {
        return [vertA, vertB, vertC]
    }
    public init(_ vertA: G3Vert, _ vertB: G3Vert, _ vertC: G3Vert) {
        self.vertA = vertA
        self.vertB = vertB
        self.vertC = vertC
    }
}

//public struct G3Poly {
//    public let verts: [G3Vert]
//    public init(verts: [G3Vert]) {
//        self.verts = verts
//    }
//}

//public struct G3Quad {
//}
