extends Node2D

# Variables
@export var FallingArrow:PackedScene

@onready var UpArrow = $UpArrow
@onready var DownArrow = $DownArrow
@onready var LeftArrow = $LeftArrow
@onready var RightArrow = $RightArrow

@onready var _background = %Background

@export var _startYPos:int = 1000

var data:GameData

func _ready() -> void:
	# Add signals
	Conductor.s_measure.connect(BeatTracker)
	
func StartGame(gameData:GameData) -> void:
	data = gameData
	_background.sprite_frames = data.Background
	_background.play("Default")
	Conductor.Setup(data.AudioData.Audio, data.AudioData.BMP, data.Patterns.size(), true, data.AudioData.FreeBeats)
	
# add exit function
	
func BeatTracker(beat:int) -> void:
	var pattern =data.Patterns[beat - 1]
	
	if pattern.Up:
		SpawnArrow(1)
	
	if pattern.Down:
		SpawnArrow(2)
		
	if pattern.Left:
		SpawnArrow(3)
		
	if pattern.Right:
		SpawnArrow(4)
	
	pass

func SpawnArrow(arrowType:int) -> void:
	var arrow = FallingArrow.instantiate()
	match arrowType:
		1: # up
			arrow.Setup(0,Vector2(UpArrow.position.x, _startYPos))
		2: # down
			arrow.Setup(1,Vector2(DownArrow.position.x, _startYPos))
		3: # left
			arrow.Setup(2,Vector2(LeftArrow.position.x, _startYPos))
		4: # right
			arrow.Setup(3,Vector2(RightArrow.position.x, _startYPos))
	add_child(arrow)
