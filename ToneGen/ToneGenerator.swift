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

  var buffer:AVAudioPCMBuffer!

  init(frequency:Float, amplitude:Float, format:AVAudioFormat){
    super.init()

    let sr:Float = Float(format.sampleRate)
    let samples = AVAudioFrameCount(1*sr/frequency)

    buffer = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: samples)
    buffer.frameLength = buffer.frameCapacity

    // generate sine wave
    let channels = Int(format.channelCount)
    var totalStride = channels * buffer.stride

    for var t = 0; t < Int(buffer.frameCapacity); t += totalStride {
      let w = Float(2*M_PI)*frequency
      let value = amplitude * sinf(w*Float(t)/sr)
      for var c = 0; c < channels; c++ {
        buffer.floatChannelData.memory[t+c] = Float(value)
      }
    }
  }

  override func play()  {
    super.play()
    scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
  }
}