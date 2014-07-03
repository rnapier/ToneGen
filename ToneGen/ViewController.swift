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

  var toneGenerator: ToneGenerator!

  let engine = AVAudioEngine()

  override func viewDidLoad() {
    super.viewDidLoad()

    let mixer = engine.mainMixerNode;
    toneGenerator = ToneGenerator(frequency: frequencySlider.value, amplitude: amplitudeSlider.value, format:mixer.outputFormatForBus(0))
    engine.attachNode(toneGenerator)
    engine.connect(toneGenerator, to: mixer, format: toneGenerator.outputFormatForBus(0))

    engine.startAndReturnError(nil)

    toneGenerator.play()
  }

  @IBAction func settingsDidChange() {
    updateToneGenerator()
    toneGenerator.play()
  }

  func updateToneGenerator() {
    if let tg = toneGenerator {
      tg.stop()
      engine.detachNode(tg)
    }

    let mixer = engine.mainMixerNode;

    frequencyLabel.text = NSString(format:"%d", Int(frequencySlider.value))
    toneGenerator = ToneGenerator(frequency: frequencySlider.value, amplitude: amplitudeSlider.value, format:mixer.outputFormatForBus(0))
    engine.attachNode(toneGenerator)
    engine.connect(toneGenerator, to: mixer, format: toneGenerator.outputFormatForBus(0))
  }
}

