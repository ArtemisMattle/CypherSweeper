extends Node

var masterMute: bool = false
var musicMute: bool = false
var soundMute: bool = false

enum sMode {normal, fast, zippy}
var speedMode: int = sMode.normal
