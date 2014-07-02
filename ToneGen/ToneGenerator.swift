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

  var ae:AVAudioEngine
  var player:AVAudioPlayerNode
  var mixer:AVAudioMixerNode
  var buffer:AVAudioPCMBuffer

  var frequency:Double
  var amplitude:Double

  init(frequency freq:Double, amplitude amp:Double){
    frequency = freq
    amplitude = amp

    // initialize objects
    ae = AVAudioEngine()
    player = AVAudioPlayerNode()
    mixer = ae.mainMixerNode;
    buffer = AVAudioPCMBuffer(PCMFormat: player.outputFormatForBus(0), frameCapacity: 100)
    buffer.frameLength = 100

    // generate sine wave
    var sr:Float = Float(mixer.outputFormatForBus(0).sampleRate)
    var n_channels = mixer.outputFormatForBus(0).channelCount

    for var i = 0; i < Int(buffer.frameLength); i+=Int(n_channels) {
      var val = sinf(441.0*Float(i)*2*Float(M_PI)/sr)

      buffer.floatChannelData.memory[i] = val * 0.5
    }

    // setup audio engine
    ae.attachNode(player)
    ae.connect(player, to: mixer, format: player.outputFormatForBus(0))
    ae.startAndReturnError(nil)

    // play player and buffer
    player.play()
    player.scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
    
  }
}