//
//  ToneGenerator.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Foundation
import AVFoundation

class ToneGenerator : AVAudioPlayerNode {

  var buffer:SineWaveAudioBuffer

  var frequency:Float {
  didSet(newFrequency) {
    buffer = SineWaveAudioBuffer(frequency:newFrequency, amplitude:amplitude, format:format)
  }
  }

  var amplitude:Float {
  didSet(newAmplitude) {
    buffer = SineWaveAudioBuffer(frequency:frequency, amplitude:newAmplitude, format:format)
  }
  }

  let format:AVAudioFormat

  init(frequency f:Float, amplitude a:Float, format form:AVAudioFormat){
    frequency = f
    amplitude = a
    format = form
    buffer = SineWaveAudioBuffer(frequency:frequency, amplitude:amplitude, format:format)
    super.init()
  }

  override func play()  {
    super.play()
    scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
  }
}