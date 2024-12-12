extends Node

func move(dir: int) -> void:
	match dir:
		0:
			Input.action_press("move up")
			Input.action_press("move left")
		1: Input.action_press("move up")
		2:
			Input.action_press("move up")
			Input.action_press("move right")
		3: Input.action_press("move right")
		4:
			Input.action_press("move down")
			Input.action_press("move right")
		5: Input.action_press("move down")
		6:
			Input.action_press("move down")
			Input.action_press("move left")
		7: Input.action_press("move left")

func stop() -> void:
	Input.action_release("move up")
	Input.action_release("move right")
	Input.action_release("move down")
	Input.action_release("move left")
