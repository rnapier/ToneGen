//
//  SineWaveAudioBuffer.swift
//  ToneGen
//
//  Created by Rob Napier on 7/3/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Foundation
import AVFoundation

class SineWaveAudioBuffer: AVAudioPCMBuffer {

    init?(frequency: Double, amplitude: Double, format: AVAudioFormat) {
        assert(frequency >= 0, "Frequency must not be negative")
        assert(amplitude >= 0 && amplitude <= 1.0, "Amplitude must be between 0 and 1")

        let sr = Double(format.sampleRate)
        let samples: AVAudioFrameCount = {
            guard frequency != 0 else { return 1 }
            return max(AVAudioFrameCount(sr / frequency), 1)
        }()

        super.init(pcmFormat: format, frameCapacity: samples)

        self.frameLength = self.frameCapacity

        let numChan = Int(format.channelCount)
        let w = 2 * .pi * frequency

        var maxValue = Float(0)
        for t in 0..<Int(self.frameLength) {
            let value = Float(amplitude * sin(w * Double(t) / sr))
            maxValue = max(maxValue, abs(value))
            for c in 0..<numChan {
                self.floatChannelData?[c][t] = value
            }
        }
        print(maxValue)
    }
}
