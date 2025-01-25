extends Node

# Bounds
@onready var _dialoguePanel = %DialoguePanel
# add dance object

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
			# hide dance scene
			
			var diaState = _currentState as DialogueState # cast into Dialogue State
			
			_dialoguePanel.visible = true
			_dialoguePanel.StartDialogue(diaState.Dialogue)
			
		elif _currentState is DancingState:
			_dialoguePanel.visible = false
			
			var dancingState = _currentState as DancingState # cast into Dialogue State
			
			# add what have to be called
			pass
		
	else:
		# Go to next scene / Chapters
		_dialoguePanel.visible = false
