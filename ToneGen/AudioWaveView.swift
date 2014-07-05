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
  var waveForm : AVAudioPCMBuffer? {
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

      let transform = CGAffineTransformScale(
        CGAffineTransformMakeTranslation(0, yZero),
        xScale, yScale)

      let cyclePath = cyclePathWithValues(vals)
      let path = pathFromCycle(cyclePath, cycleWidth:Float(valCount), totalWidth:width)

      path.applyTransform(transform)
      path.stroke()
    }
  }

  func cyclePathWithValues(values:Float[]) -> UIBezierPath {
    let cycle = UIBezierPath()
    let valCount = values.count

    cycle.moveToPoint(CGPointZero)
    for t in 0..valCount {
      cycle.addLineToPoint(CGPointMake(Float(t), values[t]))
    }
    cycle.addLineToPoint(CGPointMake(Float(valCount), values[0]))
    return cycle
  }

  func pathFromCycle(cycle: UIBezierPath, cycleWidth:Float, totalWidth:Float) -> UIBezierPath {
    let cycleOffset = CGAffineTransformMakeTranslation(cycleWidth, 0)
    let path = UIBezierPath()
    do {
      path.appendPath(cycle)
      cycle.applyTransform(cycleOffset)
    } while path.currentPoint.x < totalWidth
    return path
  }
}
