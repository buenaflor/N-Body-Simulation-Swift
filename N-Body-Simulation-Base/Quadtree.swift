//
//  Quadtree.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 27.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Foundation

class Quadtree {
  private var boundingBox: BoundingBox2D
  private var body: CelestialBody?
  private var pseudoBody: CelestialBody?
  
  private var SW: Quadtree?
  private var NW: Quadtree?
  private var SE: Quadtree?
  private var NE: Quadtree?

  private var isLeaf: Bool {
    return SW == nil
  }
  
  init(boundingBox: BoundingBox2D) {
    self.boundingBox = boundingBox
  }
  
  /// Returns true if the position of this body is inside the bounding box
  func contains(body: CelestialBody) -> Bool {
    return body.inside(boundingBox: boundingBox)
  }
  
  /// Inserts a body into the quad tree
  func insert(body: CelestialBody) {
    guard contains(body: body) else {
      return
    }
    if isLeaf {
      if self.body == nil {
        self.pseudoBody = body
        self.body = body
      } else {
        // We're at a leaf, but there is a body
        // Remove the body and split this node into 4 children
        // Then insert the old and new body into the correct quadrants
        
        let newBody = body
        let oldBody = self.body!
        self.body = nil
        
        self.pseudoBody = newBody.createPseudobody(with: oldBody)

        self.computeNewQuadTrees()
        
        self.insertNode(body: oldBody)
        self.insertNode(body: newBody)
      }
    } else {
      self.pseudoBody = body.createPseudobody(with: self.pseudoBody!)
      self.insertNode(body: body)
    }
  }
  
  /// Updates the force applied on the given body b based on the Barnes Hut Algorithm
  /// It approximates the force calculation based on the pseudo body, if the conditions are met
  /// In the worst case, the algorithm goes to the leafs to calculate forces directly with the body
  func updateForce(body: CelestialBody) {
    if isLeaf {
      if (self.body != body && self.body != nil) {
        body.calculateForce(body: self.body!)
      }
    } else if ((self.boundingBox.halfLength * 2) / (body.distance(to: self.pseudoBody!)) < Simulation.Theta) {
      body.calculateForce(body: self.pseudoBody!)
    } else {
      if SW != nil { SW?.updateForce(body: body) }
      if NW != nil { NW?.updateForce(body: body) }
      if SE != nil { SE?.updateForce(body: body) }
      if NE != nil { NE?.updateForce(body: body) }
    }
  }
  
  /// Draws only leaf quadrants
  func drawLeafQuads() {
    if isLeaf && body != nil {
      boundingBox.drawBorder()
    }
    if SW != nil { SW?.drawLeafQuads() }
    if NW != nil { NW?.drawLeafQuads() }
    if SE != nil { SE?.drawLeafQuads() }
    if NE != nil { NE?.drawLeafQuads() }
  }
  
  /// Draws all quadrants
  func drawAllQuads() {
    boundingBox.drawBorder()
    if SW != nil { SW?.drawAllQuads() }
    if NW != nil { NW?.drawAllQuads() }
    if SE != nil { SE?.drawAllQuads() }
    if NE != nil { NE?.drawAllQuads() }
  }
  
  /// Recursively inserts a body into the right quadrant
  private func insertNode(body: CelestialBody) {
    let pos = body.quadPosition(in: boundingBox)
    if (pos == 0) { SW?.insert(body: body) }
    if (pos == 1) { NW?.insert(body: body) }
    if (pos == 2) { SE?.insert(body: body) }
    if (pos == 3) { NE?.insert(body: body) }
  }
  
  /// Computes the new quad trees for this node
  private func computeNewQuadTrees() {
    SW = Quadtree(boundingBox: boundingBox.SW())
    NW = Quadtree(boundingBox: boundingBox.NW())
    SE = Quadtree(boundingBox: boundingBox.SE())
    NE = Quadtree(boundingBox: boundingBox.NE())
  }
}
