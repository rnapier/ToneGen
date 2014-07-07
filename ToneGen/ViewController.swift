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

    self.configureToneGenerator()
    self.configureEngine()
    self.toneGenerator.play()
    self.updateWaveView()
  }

  @IBAction func settingsDidChange() {
    self.updateToneGenerator()
  }

  func configureToneGenerator() {
    let mixer = self.engine.mainMixerNode;
    self.toneGenerator = ToneGenerator(format:mixer.outputFormatForBus(0))
    self.updateToneGenerator()
  }

  func configureEngine() {
    let eng = self.engine
    eng.attachNode(self.toneGenerator)
    eng.connect(self.toneGenerator, to: eng.mainMixerNode, format: nil)
    eng.startAndReturnError(nil)  // FIXME: error check
  }

  func updateWaveView() {
    self.audioWaveView.waveForm = self.toneGenerator.buffer
  }

  func updateToneGenerator() {
    self.toneGenerator.amplitude = self.amplitudeSlider.value
    self.toneGenerator.frequency = self.frequencySlider.value
    self.frequencyLabel.text = NSString(format:"%d", Int(frequencySlider.value))
    self.updateWaveView()
  }
}
