//
//  BoundingBox2D.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 27.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Foundation

struct BoundingBox2D {
  private(set) var center: Vector2D
  private(set) var halfLength: Double
  
  init(center: Vector2D, halfLength: Double) {
    self.center = center
    self.halfLength = halfLength
  }
  
  /// Returns true if position is inside the bounding box
  func contains(position: Vector2D) -> Bool {
    let lower = center.plus(vector: Vector2D(x: -halfLength, y: -halfLength))
    let upper = center.plus(vector: Vector2D(x: halfLength, y: halfLength))
    return position.greaterOrEqual(than: lower) && position.lessOrEqual(than: upper)
  }
  
  /// Draws this bounding box
  func drawBorder() {
    center.drawSquare(with: .green, halfLength: halfLength)
  }
  
  /*
   Quad Position
   child: 0 1 2 3
   x:     - - + +
   y:     - + - +
   */
  
  /// Returns the bounding box index in which this vector falls into
  func quadPosition(for position: Vector2D) -> Int {
    var quad = 0
    if (position.x >= center.x) { quad |= 2 }
    if (position.y >= center.y) { quad |= 1 }
    return quad
  }
  
  /// Subdivides this bounding box and returns the South-West bounding box
  func SW() -> BoundingBox2D {
    let newCenter = center.minus(vector: Vector2D(x: halfLength / 2, y: halfLength / 2))
    return BoundingBox2D(center: newCenter, halfLength: halfLength / 2)
  }
  
  /// Subdivides this bounding box and returns the North-West bounding box
  func NW() -> BoundingBox2D {
    let addVector = Vector2D(x: -halfLength / 2, y: halfLength / 2)
    let newCenter = center.plus(vector: addVector)
    return BoundingBox2D(center: newCenter, halfLength: halfLength / 2)
  }
  
  /// Subdivides this bounding box and returns the South-East bounding box
  func SE() -> BoundingBox2D {
    let addVector = Vector2D(x: halfLength / 2, y: -halfLength / 2)
    let newCenter = center.plus(vector: addVector)
    return BoundingBox2D(center: newCenter, halfLength: halfLength / 2)
  }
  
  /// Subdivides this bounding box and returns the North-East bounding box
  func NE() -> BoundingBox2D {
    let newCenter = center.plus(vector: Vector2D(x: halfLength / 2, y: halfLength / 2))
    return BoundingBox2D(center: newCenter, halfLength: halfLength / 2)
  }
}
