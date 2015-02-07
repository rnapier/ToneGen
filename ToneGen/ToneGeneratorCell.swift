//
//  ToneGeneratorViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 7/7/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class ToneGeneratorCell : UITableViewCell {
  @IBOutlet var frequencySlider: UISlider?
  @IBOutlet var frequencyLabel: UILabel?
  @IBOutlet var amplitudeSlider: UISlider?

  var toneGenerator: ToneGenerator? {
  didSet {
    if let tg = toneGenerator {
      enabled = true
      frequencySlider?.value = tg.frequency
      amplitudeSlider?.value = tg.amplitude
      updateToneGenerator()
    }
    else {
      enabled = false
    }
  }
  }

  var enabled:Bool = false {
  didSet {
    frequencySlider?.enabled = enabled
    amplitudeSlider?.enabled = enabled
  }
  }

  var frequency:Float {
  get {
    return frequencySlider?.value ?? 0
  }
  }

  var amplitude:Float {
  get {
    return amplitudeSlider?.value ?? 0
  }
  }

  @IBAction func settingsDidChange() {
    updateToneGenerator()
  }

  func updateToneGenerator() {
    if let toneGenerator = toneGenerator {
      toneGenerator.amplitude = self.amplitudeSlider?.value ?? 0
      toneGenerator.frequency = self.frequencySlider?.value ?? 0
      self.frequencyLabel?.text = NSString(format:"%d", Int(frequencySlider?.value ?? 0))
    }
  }
}