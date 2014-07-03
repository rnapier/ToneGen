//
//  AudioWaveView.swift
//  ToneGen
//
//  Created by Rob Napier on 7/3/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import AVFoundation

class AudioWaveView : UIView {
  var waveForm : AVAudioPCMBuffer?

  init(coder aDecoder: NSCoder!) {
    super.init(coder:aDecoder)
    layer.borderWidth = 1
  }

//  override func drawRect(rect: CGRect) {
//    if let wave = waveForm {
//      let numChan = Int(wave.format.channelCount)
//      let totalStride = numChan * wave.stride
//      let length = wave.frameLength
//
//      let memory = wave.floatChannelData.memory
//
//      let data = Float[]()
//      for var t = 0; t < Int(frameCapacity); t += totalStride {
//        let value = amplitude * sinf(w*Float(t)/sr)
//        for var c = 0; c < numChan; c++ {
//          mem[t+c] = value
//        }
//      }
//    }
//  }

}
