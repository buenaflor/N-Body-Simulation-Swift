//
//  CelestialBody.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 26.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

class CelestialBody {
  private var position: Vector2D
  private var velocity: Vector2D
  private var force: Vector2D
  private var mass: Double
  private var color: NSColor
  
  init(position: Vector2D, velocity: Vector2D, mass: Double, color: NSColor) {
    self.position = position
    self.velocity = velocity
    self.mass = mass
    self.color = color
    self.force = Vector2D()
  }
  
  convenience init(posX: Double, posY: Double, velX: Double, velY: Double, mass: Double, color: NSColor) {
    self.init(position: Vector2D(x: posX, y: posY),
              velocity: Vector2D(x: velX, y: velY),
              mass: mass,
              color: color)
  }
  
  /// Return the euclidean distance between two bodies
  func distance(to body: CelestialBody) -> Double {
    return position.distance(to: body.position)
  }
  
  /// Returns the correct position index for this body inside the bounding box
  func quadPosition(in boundingBox: BoundingBox2D) -> Int {
    return boundingBox.quadPosition(for: position)
  }
  
  /// Returns true if this body is inside the bounding box
  func inside(boundingBox: BoundingBox2D) -> Bool {
    return boundingBox.contains(position: position)
  }
  
  /// Draws this body as a point
  func draw() {
    position.drawPoint(with: color)
  }

  /// Calculate the force applied on this body by the specified 'body'
  func calculateForce(body: CelestialBody) {
    var direction = body.position.minus(vector: position)
    let r = direction.length
    direction.normalize()
    let F = Simulation.G * body.mass * mass / (r * r)
    force = direction.times(by: F).plus(vector: force)
  }
  
  /// Resets the force to 0 because the forces exterted on bodies need to be recalculated after moving
  func resetForces() {
    force.reset()
  }
  
  /// Allows to accelerate and deccelerate the simulation by changing dt
  /// This method is based on the leapfrog method
  func update(dt: Double) {
    velocity = force.times(by: dt / mass).plus(vector: velocity)
    position = velocity.times(by: dt).plus(vector: position)
  }
  
  /// Represents the center of mass of a specific quadrant/square. It is not a real body
  func createPseudobody(with body: CelestialBody) -> CelestialBody {
    let combinedMass = mass + body.mass
    let combinedPosition = position.times(by: mass).plus(vector: body.position.times(by: body.mass)).divided(by: combinedMass)
    let combinedBody = CelestialBody(position: combinedPosition, velocity: Vector2D(), mass: combinedMass, color: .white)
    return combinedBody
  }
}

extension CelestialBody: Equatable {
  static func ==(lhs: CelestialBody, rhs: CelestialBody) -> Bool {
    return lhs.position == rhs.position && lhs.mass == rhs.mass && lhs.velocity == rhs.velocity && lhs.force == rhs.force
  }
}
