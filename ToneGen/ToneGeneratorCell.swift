//
//  ToneGeneratorViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 7/7/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

let frequencies = [63, 125, 250, 500, 1000, 2000, 4000]
let gainRange = -12...12
let baseAmplitude = 0.063 // 10^(-12/10); max gain = 1.0 (no clipping)

class ToneGeneratorCell : UITableViewCell {
    @IBOutlet weak var frequencySlider: UISlider?
    @IBOutlet weak var frequencyLabel: UILabel?
    @IBOutlet weak var gainSlider: UISlider?
    @IBOutlet weak var gainLabel: UILabel!

    override func awakeFromNib() {
        frequencySlider?.minimumValue = 0
        frequencySlider?.maximumValue = Float(frequencies.count - 1)
        frequencySlider?.value = 0
        updateToneGenerator()
    }

    var toneGenerator: ToneGenerator? {
        didSet {
            if let tg = toneGenerator {
                enabled = true
                frequencySlider?.value = Float(tg.frequency)
                gainSlider?.value = Float(tg.amplitude)
                updateToneGenerator()
            }
            else {
                enabled = false
            }
        }
    }

    var enabled:Bool = false {
        didSet {
            frequencySlider?.isEnabled = enabled
            gainSlider?.isEnabled = enabled
        }
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
        let freqSelection = Int(sender.value)
        sender.value = Float(freqSelection)

        frequency = frequencies[freqSelection]
    }

    @IBAction func updateGain(_ sender: UISlider) {
        gain = Int(sender.value)
        sender.value = Float(gain)
    }

    func updateToneGenerator() {
        if let toneGenerator = toneGenerator {
            let formatter = NumberFormatter()

            let amplitude = __exp10(Double(gain)/10.0) * baseAmplitude

            toneGenerator.amplitude = amplitude
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            gainLabel?.text = formatter.string(from: gain as NSNumber)

            toneGenerator.frequency = Double(frequency)
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            frequencyLabel?.text = formatter.string(from: frequency as NSNumber) ?? ""

        }
    }
}
