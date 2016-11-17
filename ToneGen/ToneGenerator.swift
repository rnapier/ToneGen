//
//  ToneGenerator.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Foundation
import AVFoundation

class ToneGenerator: AVAudioPlayerNode {

    fileprivate var buffer: SineWaveAudioBuffer?

    var frequency: Double {
        didSet {
            updateTone()
        }
    }

    var amplitude: Double {
        didSet {
            updateTone()
        }
    }

    fileprivate let format: AVAudioFormat

    init(frequency: Double, amplitude: Double, format: AVAudioFormat) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.format = format
        super.init()
    }

    convenience init(format: AVAudioFormat) {
        self.init(frequency: 0, amplitude: 0, format: format)
    }

    override func play() {
        super.play()
        updateTone()
    }

    func updateTone() {
        guard self.engine != nil else { return }
        buffer = SineWaveAudioBuffer(frequency: frequency, amplitude: amplitude, format: self.format)
        scheduleBuffer(buffer!, at: nil, options: [.loops, .interruptsAtLoop], completionHandler: nil)
    }
}
