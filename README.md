
# GEO3D

```
let engine: GEO3DEngine = GEO3DScnEngine()
let root: GEO3DRoot = GEO3DScnRoot(size: view.bounds.size)
view.addSubview(root.view)

var sphere = engine.create(.sphere)
root.add(sphere)
```
