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
  didSet {
    DispatchQueue.main.async {
      self.setNeedsDisplay()
    }
  }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    layer.borderWidth = 1
    layer.isGeometryFlipped = true
  }

  override func draw(_ rect: CGRect) {
    if let waveForm = waveForm {
      let vals = waveForm.graphableValues()

      let width  = bounds.width
      let height = bounds.height

      let yZero  = bounds.midY
      let xScale = CGFloat(1)
      let yScale = height/2

      let transform = CGAffineTransform(translationX: 0, y: yZero).scaledBy(x: xScale, y: yScale)

      let cyclePath = cyclePathWithValues(vals)
      let path = pathFromHorizontallyRepeatedCycle(cyclePath, totalWidth:width)

      path.apply(transform)
      path.stroke()
    }
  }
}

func cyclePathWithValues(_ values:[Float]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.move(to: CGPoint.zero)
  for t in 0..<valCount {
    cycle.addLine(to: CGPoint(x: CGFloat(t), y: CGFloat(values[t])))
  }
  cycle.addLine(to: CGPoint(x: CGFloat(valCount), y: CGFloat(values[0])))
  return cycle
}


func pathFromHorizontallyRepeatedCycle(_ cycle: UIBezierPath, totalWidth:CGFloat) -> UIBezierPath {
  let cycleOffset = CGAffineTransform(translationX: cycle.bounds.width, y: 0)
  let path = UIBezierPath()
  repeat {
    path.append(cycle)
    cycle.apply(cycleOffset)
  } while path.currentPoint.x < totalWidth
  return path
}
