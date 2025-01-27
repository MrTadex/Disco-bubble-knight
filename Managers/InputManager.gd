extends Node

signal SkipLine

signal UpArrow
signal DownArrow
signal LeftArrow
signal RightArrow

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				SkipLine.emit()
			KEY_UP, KEY_W:
				UpArrow.emit()
			KEY_DOWN, KEY_S:
				DownArrow.emit()
			KEY_LEFT, KEY_A:
				LeftArrow.emit()
			KEY_RIGHT, KEY_D:
				RightArrow.emit()
				
