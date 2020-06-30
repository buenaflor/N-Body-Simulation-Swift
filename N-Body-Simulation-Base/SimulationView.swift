//
//  SimulationView.swift
//  N-Body-Simulation-Base
//
//  Created by Giancarlo Buenaflor on 28.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

class SimulationView: NSView {
  private var celestialBodies: [CelestialBody] = []
  private var boundingBox: BoundingBox2D?
  
  var dt = 0.1
  var drawLeafQuadsEnabled = false
  var drawAllQuadsEnabled = false
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    let quadtree = Quadtree(boundingBox: boundingBox!)
    for body in celestialBodies {
      quadtree.insert(body: body)
    }
    
    for body in celestialBodies {
      body.resetForces()
      if quadtree.contains(body: body) {
        quadtree.updateForce(body: body)
        body.update(dt: dt)
      }
    }
    
    for body in celestialBodies {
      body.draw()
    }
    
    if drawLeafQuadsEnabled { quadtree.drawLeafQuads() }
    if drawAllQuadsEnabled { quadtree.drawAllQuads() }
  }
  
  func setBodies(_ bodies: [CelestialBody]) {
    celestialBodies = bodies
  }
  
  func setBoundingBox(_ bbox: BoundingBox2D) {
    boundingBox = bbox
  }
  
  func updateDrawing() {
    setNeedsDisplay(frame)
  }
}
