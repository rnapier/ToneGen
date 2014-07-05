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
    layer.geometryFlipped = true
  }

  override func drawRect(rect: CGRect) {
    if let wave = waveForm {
      let vals = wave.firstChannel()
      let valCount = vals.count

      let width  = bounds.width
      let height = bounds.height
      let yZero  = Float(CGRectGetMidY(bounds))
      let xScale = Float(1)
      let yScale = Float(height/2)

      var path = UIBezierPath()
      path.moveToPoint(CGPointMake(0, yZero))

      var x:CGFloat = 0
      while x < width {
        for var t = 0; x < width && t < valCount; t++ {
          let y = vals[t] * yScale + yZero
          path.addLineToPoint(CGPointMake(x, y))
          x += xScale
        }
        path.stroke()
      }
    }
  }

}
