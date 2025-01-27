extends AnimatedSprite2D

@export var _heightCheck: int = -600

func Setup(sprite:int, pos:Vector2) -> void:
	frame = sprite
	position = pos

func _physics_process(delta: float) -> void:
	position.y += -10
	
	if position.y < _heightCheck:
		print("miss")
		queue_free()
