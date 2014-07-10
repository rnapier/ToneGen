//
//  ViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import AVFoundation

extension AVAudioPCMBuffer : GraphableWaveForm {
  func graphableValues() -> [Float] {
    return [Float](UnsafeArray(
      start: self.floatChannelData[0],
      length: Int(self.frameLength)))
  }
}

class AudioViewController: UIViewController, UITableViewDataSource {
                            
  @IBOutlet var audioWaveView: AudioWaveView
  @IBOutlet var audioModulesTableView: UITableView

  var audioModules = [ToneGenerator]()

  let engine = AVAudioEngine()

  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return audioModules.count
  }

  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let cell = tableView.dequeueReusableCellWithIdentifier("toneGenerator") as ToneGeneratorCell
    cell.toneGenerator = audioModules[indexPath.row]
    return cell
  }

  @IBAction func addToneGenerator(sender: UIButton) {
    let tg = ToneGenerator(frequency: 410, amplitude: 0.5, format: engine.mainMixerNode.outputFormatForBus(0))
    engine.attachNode(tg)
    engine.connect(tg, to:engine.mainMixerNode, format:nil)
    if audioModules.count == 0 {
      engine.startAndReturnError(nil)
      let output = engine.outputNode

      let block: AVAudioNodeTapBlock = {(buffer, time) in
        self.audioWaveView.waveForm = buffer
      }

      output.installTapOnBus(0, bufferSize: AVAudioFrameCount(1000), format: nil, block: block)
    }
    tg.play()

    audioModules.append(tg)
    audioModulesTableView.reloadData()
  }
}