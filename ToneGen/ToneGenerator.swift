//
//  ToneGenerator.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Foundation
import AVFoundation

class ToneGenerator : AVAudioPlayerNode {

    var buffer:SineWaveAudioBuffer?

    var frequency:Float {
        didSet(freq) {
            self.updateTone()
        }
    }

    var amplitude:Float {
        didSet(amp) {
            self.updateTone()
        }
    }

    let format:AVAudioFormat

    init(frequency freq:Float, amplitude amp:Float, format fmt:AVAudioFormat){
        frequency = freq
        amplitude = amp
        format = fmt
        super.init()
    }

    convenience init(format fmt:AVAudioFormat) {
        self.init(frequency:0, amplitude:0, format:fmt)
    }

    override func play()  {
        super.play()
        self.updateTone()
    }

    func updateTone() {
        if (self.engine != nil) {
            let buffer = SineWaveAudioBuffer(frequency:self.frequency, amplitude:self.amplitude, format:self.format)
            self.scheduleBuffer(buffer, atTime: nil, options: [.Loops, .InterruptsAtLoop], completionHandler: nil)
            self.buffer = buffer
        }
    }
}
