extends Node

var masterMute: bool = false
var musicMute: bool = false
var soundMute: bool = false
var colourblindMode: bool = true

enum sMode {normal, fast, zippy}
var speedMode: int = sMode.normal
