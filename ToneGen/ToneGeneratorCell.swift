//
//  ToneGeneratorViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 7/7/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class ToneGeneratorCell : UITableViewCell {
    @IBOutlet weak var frequencySlider: UISlider?
    @IBOutlet weak var frequencyLabel: UILabel?
    @IBOutlet weak var amplitudeSlider: UISlider?
    @IBOutlet weak var amplitudeLabel: UILabel!

    var toneGenerator: ToneGenerator? {
        didSet {
            if let tg = toneGenerator {
                enabled = true
                frequencySlider?.value = Float(tg.frequency)
                amplitudeSlider?.value = Float(tg.amplitude)
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
            amplitudeSlider?.isEnabled = enabled
        }
    }

    var frequency:Float {
        get {
            return frequencySlider?.value ?? 0
        }
    }

    var amplitude:Float {
        get {
            return amplitudeSlider?.value ?? 0
        }
    }

    @IBAction func settingsDidChange() {
        updateToneGenerator()
    }

    func updateToneGenerator() {
        if let toneGenerator = toneGenerator {
            toneGenerator.amplitude = Double(self.amplitudeSlider?.value ?? 0)
            toneGenerator.frequency = Double(self.frequencySlider?.value ?? 0)
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            frequencyLabel?.text = formatter.string(from: frequencySlider?.value as NSNumber? ?? 0) ?? ""

            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            amplitudeLabel?.text = formatter.string(from: amplitudeSlider?.value as NSNumber? ?? 0) ?? ""

        }
    }
}
