//
//  AudioWaveView.swift
//  ToneGen
//
//  Created by Rob Napier on 7/3/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

protocol GraphableWaveForm {
  func graphableValues() -> CGFloat[]
}

class AudioWaveView : UIView {
  var waveForm : GraphableWaveForm? {
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
    if let waveForm = waveForm {
      let vals = waveForm.graphableValues()
      let valCount = vals.count

      let width  = bounds.width
      let height = bounds.height

      let yZero  = CGFloat(CGRectGetMidY(bounds))
      let xScale = CGFloat(1)
      let yScale = CGFloat(height/2)

      let transform = CGAffineTransformScale(
        CGAffineTransformMakeTranslation(0, yZero),
        xScale, yScale)

      let cyclePath = cyclePathWithValues(vals)
      let path = pathFromCycle(cyclePath, cycleWidth:CGFloat(valCount), totalWidth:width)

      path.applyTransform(transform)
      path.stroke()
    }
  }

  func cyclePathWithValues(values:CGFloat[]) -> UIBezierPath {
    let cycle = UIBezierPath()
    let valCount = values.count

    cycle.moveToPoint(CGPointZero)
    for t in 0..valCount {
      cycle.addLineToPoint(CGPointMake(CGFloat(t), values[t]))
    }
    cycle.addLineToPoint(CGPointMake(CGFloat(valCount), values[0]))
    return cycle
  }

  func pathFromCycle(cycle: UIBezierPath, cycleWidth:CGFloat, totalWidth:CGFloat) -> UIBezierPath {
    let cycleOffset = CGAffineTransformMakeTranslation(cycleWidth, 0)
    let path = UIBezierPath()
    do {
      path.appendPath(cycle)
      cycle.applyTransform(cycleOffset)
    } while path.currentPoint.x < totalWidth
    return path
  }
}
