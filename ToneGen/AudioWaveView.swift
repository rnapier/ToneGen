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
  var waveForm : SineWaveAudioBuffer? {
  didSet(w) {
    setNeedsDisplay()
  }
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder:aDecoder)
    layer.borderWidth = 1
  }

  override func drawRect(rect: CGRect) {
    if let wave = waveForm {
      let firstChannel = wave.firstChannel()

      let width = bounds.width
      let height = bounds.height
      let zeroY = CGRectGetMidY(bounds)
      let pixelsPerSample = Float(width)/Float(firstChannel.count)

      var path = UIBezierPath()
      path.moveToPoint(CGPointMake(0, zeroY))

      for var t = 0; t < firstChannel.count; t++ {
        path.addLineToPoint(CGPointMake(
          Float(t)*pixelsPerSample,
          firstChannel[Int(t)] * Float(height) + Float(zeroY)))
      }

      UIColor.blackColor().set()
      path.stroke()
    }
  }

}
