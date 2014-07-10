//
//  ViewController.swift
//  ToneGen
//
//  Created by Rob Napier on 6/30/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import AVFoundation

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
    }
    tg.play()

    audioModules.append(tg)
    audioModulesTableView.reloadData()
  }
}
