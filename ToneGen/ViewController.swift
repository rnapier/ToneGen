//
//  ViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
  @IBOutlet var frequencySlider: UISlider
  @IBOutlet var amplitudeSlider: UISlider
  var toneGenerator: ToneGenerator!

  override func viewDidLoad() {
    super.viewDidLoad()
    toneGenerator = ToneGenerator(frequency: Double(frequencySlider.value), amplitude: Double(amplitudeSlider.value))
  }

  @IBAction func settingsDidChange() {
    updateToneGenerator()
  }

  func updateToneGenerator() {
    toneGenerator.frequency = Double(frequencySlider.value)
    toneGenerator.amplitude = Double(amplitudeSlider.value)
  }
}

