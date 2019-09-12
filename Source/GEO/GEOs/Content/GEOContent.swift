//
//  GEOContent.swift
//  GEO3D
//
//  Created by Anton Heestand on 2019-09-12.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation

public class GEOContent: GEO {
    
    var obj: G3Obj
    
    init(obj: G3Obj) {
        
        self.obj = obj
        
        super.init()
        
        root.add(obj)
        
    }

}
