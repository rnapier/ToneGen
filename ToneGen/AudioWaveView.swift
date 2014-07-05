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

      // Build one cycle
      let cycle = UIBezierPath()
      cycle.moveToPoint(CGPointMake(0, yZero))
      for var t = 0; t < valCount; t++ {
        let y = vals[t] * yScale + yZero
        cycle.addLineToPoint(CGPointMake(Float(t), y))
      }
      cycle.addLineToPoint(CGPointMake(Float(valCount), vals[0] * yScale + yZero))

      let transform = CGAffineTransformMakeTranslation(Float(valCount), 0)

      var path = UIBezierPath()
      do {
        path.appendPath(cycle)
        cycle.applyTransform(transform)
      } while path.currentPoint.x < width

      path.stroke()
    }
  }
  
}
