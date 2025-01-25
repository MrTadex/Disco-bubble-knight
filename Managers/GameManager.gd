extends Node

# Bounds
@onready var _dialoguePanel = %DialoguePanel
# add game

# Variables
@export var _flow:Array[DialogueData] # add class for triggers
var _flowIndex = -1

var _currentState

func _ready() -> void:
	StartNextState()

func StartNextState() -> void:
	_flowIndex += 1
	
	if(_flowIndex < _flow.size()):
		_currentState = _flow[_flowIndex]
		
		# add state switch
		_dialoguePanel.visible = true
		_dialoguePanel.StartDialogue(_currentState)
	else:
		# Go to next scene / Chapters
		_dialoguePanel.visible = false
