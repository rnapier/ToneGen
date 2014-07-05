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

      let cycle = cyclePath(vals)

      let cycleOffset = CGAffineTransformMakeTranslation(Float(valCount), 0)
      let path = UIBezierPath()
      do {
        path.appendPath(cycle)
        cycle.applyTransform(cycleOffset)
      } while path.currentPoint.x < width

      let transform = CGAffineTransformScale(
        CGAffineTransformMakeTranslation(0, yZero),
        xScale, yScale)

      path.applyTransform(transform)
      path.stroke()
    }
  }

  func cyclePath(values:Float[]) -> UIBezierPath {
    let cycle = UIBezierPath()
    let valCount = values.count

    cycle.moveToPoint(CGPointZero)
    for var t = 0; t < valCount; t++ {
      let y = values[t]
      cycle.addLineToPoint(CGPointMake(Float(t), y))
    }
    cycle.addLineToPoint(CGPointMake(Float(valCount), values[0]))
    return cycle
  }

}
