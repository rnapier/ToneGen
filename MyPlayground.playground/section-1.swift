// Playground - noun: a place where people can play

import Cocoa

let sr:Double = 44100
let f:Double = 11025
let amplitude:Double = 1

let w = 2*M_PI*Double(f)

for var t = 0; t < Int(sr/100); t += 1 {
//  let value = amplitude * sin(w*Double(t)/sr)
//  let other = amplitude * sin((2*M_PI*Double(t)*f)/sr)
  let x = sinf(Float(f)*Float(t)*2*Float(M_PI)/Float(sr))
}


