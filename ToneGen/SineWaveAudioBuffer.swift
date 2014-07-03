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
  init(frequency:Float, amplitude:Float, format:AVAudioFormat){

    let sr = Float(format.sampleRate)
    let samples = AVAudioFrameCount(sr/frequency)

    super.init(PCMFormat: format, frameCapacity: samples)

    frameLength = frameCapacity

    let channels = Int(format.channelCount)
    let totalStride = channels * stride
    let memory = floatChannelData.memory
    let w = Float(2*M_PI)*frequency

    for var t = 0; t < Int(frameCapacity); t += totalStride {
      let value = amplitude * sinf(w*Float(t)/sr)
      for var c = 0; c < channels; c++ {
        memory[t+c] = value
      }
    }
  }
}