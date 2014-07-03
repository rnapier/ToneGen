//
//  ViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
                            
  @IBOutlet var frequencySlider: UISlider
  @IBOutlet var amplitudeSlider: UISlider
  @IBOutlet var frequencyLabel: UILabel
  @IBOutlet var audioWaveView: AudioWaveView

  var toneGenerator: ToneGenerator!

  let engine = AVAudioEngine()

  override func viewDidLoad() {
    super.viewDidLoad()

    let mixer = engine.mainMixerNode;
    toneGenerator = ToneGenerator(format:mixer.outputFormatForBus(0))
    updateToneGenerator()

    engine.attachNode(toneGenerator)
    engine.connect(toneGenerator, to: mixer, format: toneGenerator.outputFormatForBus(0))
    engine.startAndReturnError(nil)

    toneGenerator.play()
  }

  @IBAction func settingsDidChange() {
    updateToneGenerator()
  }

  func updateToneGenerator() {
    toneGenerator.amplitude = amplitudeSlider.value
    toneGenerator.frequency = frequencySlider.value
    frequencyLabel.text = NSString(format:"%d", Int(frequencySlider.value))
  }
}

