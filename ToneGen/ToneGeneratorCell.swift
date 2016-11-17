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
                frequencySlider?.value = tg.frequency
                amplitudeSlider?.value = tg.amplitude
                updateToneGenerator()
            }
            else {
                enabled = false
            }
        }
    }

    var enabled:Bool = false {
        didSet {
            frequencySlider?.enabled = enabled
            amplitudeSlider?.enabled = enabled
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
            toneGenerator.amplitude = self.amplitudeSlider?.value ?? 0
            toneGenerator.frequency = self.frequencySlider?.value ?? 0
            let formatter = NSNumberFormatter()
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            frequencyLabel?.text = formatter.stringFromNumber(frequencySlider?.value ?? 0) ?? ""

            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            amplitudeLabel?.text = formatter.stringFromNumber(amplitudeSlider?.value ?? 0) ?? ""

        }
    }
}
