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

  var ae:AVAudioEngine!


  override func viewDidLoad() {
    super.viewDidLoad()

    ae = AVAudioEngine()

    let mixer = ae.mainMixerNode;
    toneGenerator = ToneGenerator(frequency: frequencySlider.value, amplitude: amplitudeSlider.value, format:mixer.outputFormatForBus(0))
    ae.attachNode(toneGenerator)
    ae.connect(toneGenerator, to: mixer, format: toneGenerator.outputFormatForBus(0))

    ae.startAndReturnError(nil)

    toneGenerator.play()
  }

  @IBAction func settingsDidChange() {
    updateToneGenerator()
    toneGenerator.play()
  }

  func updateToneGenerator() {
    if let tg = toneGenerator {
      tg.stop()
      ae.detachNode(tg)
    }

    let mixer = ae.mainMixerNode;

    frequencyLabel.text = NSString(format:"%d", Int(frequencySlider.value))
    toneGenerator = ToneGenerator(frequency: frequencySlider.value, amplitude: amplitudeSlider.value, format:mixer.outputFormatForBus(0))
    ae.attachNode(toneGenerator)
    ae.connect(toneGenerator, to: mixer, format: toneGenerator!.outputFormatForBus(0))
  }
}

