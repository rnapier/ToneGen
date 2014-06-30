//
//  ToneGenerator.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Foundation
import AVFoundation

class ToneGenerator {

  let toneGenerator = MGToneGenerator()

  var frequency: Double {
  get {
    return toneGenerator.frequency
  }
  set(newFreq) {
    toneGenerator.frequency = newFreq
  }
  }

  var amplitude: Double {
  get {
    return toneGenerator.amplitude
  }
  set(newAmp) {
    toneGenerator.amplitude = newAmp
  }

  }

  init(frequency freq: Double, amplitude amp: Double) {
    toneGenerator.frequency = freq
    toneGenerator.amplitude = amp
    toneGenerator.start()
  }

  deinit {
    toneGenerator.stop()
  }
}