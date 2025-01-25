extends Control

# Bounds
@onready var _skipButton := %SkipButton
@onready var _dialogueLine := %DialogueLine
@onready var _nameBubble := %NameBubble
@onready var _mainSpeaker := %MainSpeaker
@onready var _speaker := %Speaker

@onready var _lineTimer := %LineTimer

# Local variables
@export var LineTime:float = 5
var _dialogue:DialogueData
var _lineIndex:int = 0
var _currentLine:LineData

var _lineTween : Tween 

#Signal
signal DialogueEnd

func StartDialogue(dialogue:DialogueData) -> void:
	_dialogue = dialogue
	_lineIndex = -1
	GetNextLine()

func GetNextLine() -> void:
	_lineIndex += 1
	
	if (_lineIndex < _dialogue.Lines.size()):
		_currentLine = _dialogue.Lines[_lineIndex]
		_dialogueLine.visible_ratio = 0
		_dialogueLine.text = _currentLine.Line
		
		_nameBubble.SetSpeaker(_currentLine.Character)
		
		var spritePath = GetEmotion(_currentLine.Character, _currentLine.Emotion)
		print(_currentLine.Location)
		match(_currentLine.Location):
			"LEFT": # Left
				if(spritePath != ""):
					_mainSpeaker.texture = load(spritePath)
					_mainSpeaker.visible = true
				else:
					_mainSpeaker.visible = false
				_speaker.visible = false
			"RIGHT": # Right
				if(spritePath != ""):
					_speaker.texture = load(spritePath)
					_speaker.visible = true
				else:
					_speaker.visible = false
				_mainSpeaker.visible = false
			_:
				_mainSpeaker.visible = false
				_speaker.visible = false
		
		_lineTimer.start(LineTime)
		
		_lineTween = create_tween()
		_lineTween.tween_property(_dialogueLine,"visible_ratio", 1, LineTime -1)
		
	else:
		# End of Dialogue
		DialogueEnd.emit()
		pass

func Reset() -> void:
	_nameBubble.ClearSpeaker()
	_dialogueLine.text = ""
	_dialogueLine.visible_ratio = 0
	_mainSpeaker.texture = null
	_speaker.texture = null

func _on_skip_button_button_down() -> void:
	_skipButton.self_modulate = Color.GRAY

func _on_skip_button_button_up() -> void:
	_skipButton.self_modulate = Color.WHITE
	GetNextLine()
	
func _on_line_timer_timeout() -> void:
	GetNextLine()

# Helper Functions
func GetEmotion(character:CharacterData, emotion:Enums.Emotions) -> String:
	for emotionSprite in character.Emotions:
		if(emotion == emotionSprite.Emotion):
			return emotionSprite.Sprite
	return ""
