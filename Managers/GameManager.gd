extends Node

# Bounds
@onready var _dialoguePanel = %DialoguePanel
@onready var _danceGame = %Game

# Variables
@export var _flow:Array[StateBase] # add class for triggers
var _flowIndex = -1

var _currentState

func _ready() -> void:
	StartNextState()

func StartNextState() -> void:
	_flowIndex += 1
	
	if(_flowIndex < _flow.size()):
		_currentState = _flow[_flowIndex]
		
		if _currentState is DialogueState:
			_danceGame.visible = false
			
			var diaState = _currentState as DialogueState # cast into Dialogue State
			
			_dialoguePanel.visible = true
			_dialoguePanel.StartDialogue(diaState.Dialogue)
			
		elif _currentState is DancingState:
			_dialoguePanel.visible = false
			
			var dancingState = _currentState as DancingState
			
			_danceGame.visible = true
			_danceGame.StartGame(dancingState.Data)
			pass
		
	else:
		# Go to next scene / Chapters
		_dialoguePanel.visible = false
