//
//  GEORepView.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
public struct GEORepView: UIViewRepresentable {
        
    public let geo: GEO
    
    public init(geo: GEO) {
        self.geo = geo
    }
    
    public func makeUIView(context: Context) -> UIView {
        return geo.view
    }
    
    public func updateUIView(_ pixView: UIView, context: Context) {}
    
}
