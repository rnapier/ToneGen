//
//  ViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import AVFoundation

let frequencies = [63, 125, 250, 500, 1000, 2000, 4000] as [Double]
let gainRange = -45...0
let baseAmplitude = __exp10(-12.0/10) // 0.063 // 10^(-12/10); max gain = 1.0 (no clipping)

extension AVAudioPCMBuffer : GraphableWaveForm {
    func graphableValues() -> [Float] {
        return Array(UnsafeBufferPointer(
            start: floatChannelData![0],
            count: Int(frameLength)))
    }
}

class AudioViewController: UIViewController {
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var gainSlider: UISlider!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet var audioWaveView: AudioWaveView!

    lazy var toneGenerator: ToneGenerator = {
        let tg = ToneGenerator(frequency: frequencies[0], amplitude: baseAmplitude, format: self.engine.mainMixerNode.outputFormat(forBus: 0))
        self.engine.attach(tg)
        self.engine.connect(tg, to: self.engine.mainMixerNode, format:nil)
        try! self.engine.start()
        tg.play()
        return tg
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        frequencySlider.minimumValue = 0
        frequencySlider.maximumValue = Float(frequencies.count - 1)
        frequencySlider.value = 0

        gainSlider.minimumValue = Float(gainRange.lowerBound)
        gainSlider.maximumValue = Float(gainRange.upperBound)
        gainSlider.value = 0

        updateToneGenerator()
    }

    var frequency = frequencies.first! {
        didSet {
            if frequency != oldValue {
                updateToneGenerator()
            }
        }
    }

    var gain = 0 {
        didSet {
            if gain != oldValue {
                updateToneGenerator()
            }
        }
    }

    @IBAction func updateFrequency(_ sender: UISlider) {
        let freqSelection = Int(round(sender.value))
        sender.value = Float(freqSelection)

        frequency = frequencies[freqSelection]
    }

    @IBAction func updateGain(_ sender: UISlider) {
        gain = Int(round(sender.value))
        sender.value = Float(gain)
    }

    func updateToneGenerator() {
        let formatter = NumberFormatter()

        let amplitude = __exp10(Double(gain)/10.0) * baseAmplitude
//        print(amplitude)

        toneGenerator.amplitude = amplitude
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        gainLabel?.text = formatter.string(from: gain as NSNumber)

        toneGenerator.frequency = Double(frequency)
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        frequencyLabel?.text = formatter.string(from: frequency as NSNumber) ?? ""

        audioWaveView.waveForm = toneGenerator.buffer
    }

    let engine = AVAudioEngine()
}
