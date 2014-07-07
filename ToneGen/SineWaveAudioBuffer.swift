//
//  SineWaveAudioBuffer.swift
//  ToneGen
//
//  Created by Rob Napier on 7/3/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Foundation
import AVFoundation

class SineWaveAudioBuffer : AVAudioPCMBuffer {

  init(frequency:Float, amplitude:Float, format:AVAudioFormat) {
    assert(frequency >= 0, "Frequency must not be negative")

    let sr = Float(format.sampleRate)
    let samples:AVAudioFrameCount = {
      if frequency == 0 { return 1 }
      return max(AVAudioFrameCount(sr/frequency), 1)
    }()

    super.init(PCMFormat: format, frameCapacity: samples)

    frameLength = frameCapacity

    let numChan = Int(format.channelCount)
    let w = Float(2*M_PI) * frequency

//    let channels = UnsafeArray(start: floatChannelData, length: numChan)

    for t in 0..<Int(frameLength) {
      let value = amplitude * sinf(w*Float(t)/sr)
      for c in 0..<numChan {
        floatChannelData[c][t] = value
      }
    }
  }
}

extension SineWaveAudioBuffer : GraphableWaveForm {
  func graphableValues() -> [CGFloat] {

    var result:[CGFloat] = [CGFloat](count:Int(frameLength), repeatedValue:0.0)

    let firstChannel = floatChannelData[0]

    for t in 0..<Int(frameLength) {
      result[t] = CGFloat(firstChannel[t])
    }
    return result
  }
}