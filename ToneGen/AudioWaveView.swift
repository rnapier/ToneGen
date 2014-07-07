//
//  AudioWaveView.swift
//  ToneGen
//
//  Created by Rob Napier on 7/3/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

protocol GraphableWaveForm {
  func graphableValues() -> [Float]
}

class AudioWaveView : UIView {
  var waveForm : GraphableWaveForm? {
  didSet(w) {
    self.setNeedsDisplay()
  }
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder:aDecoder)
    layer.borderWidth = 1
    layer.geometryFlipped = true
  }

  override func drawRect(rect: CGRect) {
    if let waveForm = self.waveForm {
      let vals = waveForm.graphableValues()
      let valCount = vals.count

      let width  = self.bounds.width
      let height = self.bounds.height

      let yZero  = CGRectGetMidY(bounds)
      let xScale = CGFloat(1)
      let yScale = height/2

      let transform = CGAffineTransformScale(
        CGAffineTransformMakeTranslation(0, yZero),
        xScale, yScale)

      let cyclePath = cyclePathWithValues(vals)
      let path = pathFromHorizontallyRepeatedCycle(cyclePath, totalWidth:width)

      path.applyTransform(transform)
      path.stroke()
    }
  }
}

func cyclePathWithValues(values:[Float]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    cycle.addLineToPoint(CGPointMake(CGFloat(t), values[t]))
  }
  cycle.addLineToPoint(CGPointMake(CGFloat(valCount), values[0]))
  return cycle
}


func pathFromHorizontallyRepeatedCycle(cycle: UIBezierPath, #totalWidth:CGFloat) -> UIBezierPath {
  let cycleOffset = CGAffineTransformMakeTranslation(cycle.bounds.width, 0)
  let path = UIBezierPath()
  do {
    path.appendPath(cycle)
    cycle.applyTransform(cycleOffset)
  } while path.currentPoint.x < totalWidth
  return path
}
