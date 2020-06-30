//
//  ViewController.swift
//  N-Body-Simulation-Base
//
//  Created by Giancarlo Buenaflor on 28.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet var simulationView: SimulationView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    simulationView.wantsLayer = true
    simulationView.layer?.backgroundColor = NSColor.black.cgColor
    
    NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: myKeyDownEvent)
    
    let simulation = Simulation(simulationView: simulationView)
    simulation.start()
  }
  
  func myKeyDownEvent(event: NSEvent) -> NSEvent {
    if event.characters ?? "" == "s" {
      simulationView.drawLeafQuadsEnabled = !simulationView.drawLeafQuadsEnabled
    }
    if event.characters ?? "" == "q" {
      simulationView.drawAllQuadsEnabled = !simulationView.drawAllQuadsEnabled
    }
    if event.characters ?? "" == "+" {
      simulationView.dt += 0.1
    }
    if event.characters ?? "" == "-" {
      simulationView.dt -= 0.1
    }
    return event
  }
  
}

