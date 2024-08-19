extends GutTest

var player = load("res://scripts/playerController.gd")
var _player

func before_each():
	_player = player.new()

func after_each():
	_player.free()

func test_score():
	var result = _player.score()
	
	assert_between(result, 0.0, 999999999.9, "Score should be positive and below 1 billion")
