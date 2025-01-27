extends Sprite2D

@export_enum("UP", "DOWN", "LEFT", "RIGHT") var _input : int

@onready var _greatArea = $GreatArea
@onready var _excelentArea = $ExcelentArea
@onready var _goodArea = $GoodArea
@onready var _missArea = $MissArea

func _ready() -> void:
	match _input:
		0:
			InputManager.UpArrow.connect(GotInput)	
		1:
			InputManager.DownArrow.connect(GotInput)
		2:
			InputManager.LeftArrow.connect(GotInput)
		3:
			InputManager.RightArrow.connect(GotInput)

func GotInput() -> void:
	var great :Array[Area2D] = _greatArea.get_overlapping_areas()
	var excelent :Array[Area2D] = _excelentArea.get_overlapping_areas()
	var good :Array[Area2D] = _goodArea.get_overlapping_areas()
	var miss :Array[Area2D] = _missArea.get_overlapping_areas()
	
	if excelent.size() > 0:
		excelent[0].get_parent().queue_free()
		print("excelent")
	elif good.size() > 0:
		good[0].get_parent().queue_free()
		print("good")
	elif great.size() > 0:
		great[0].get_parent().queue_free()
		print("great")
	elif miss.size() > 0:
		miss[0].get_parent().queue_free()
		print("miss")
	
