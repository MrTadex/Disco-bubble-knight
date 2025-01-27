extends Control

# Bounds
@onready var _dialogueLine := %DialogueLine
@onready var _nameBubble := %NameBubble
@onready var _mainSpeaker := %MainSpeaker
@onready var _speaker := %Speaker
@onready var _background := %Background
@onready var _lineTimer := %LineTimer

# Local variables
var _dialogue:DialogueData
var _lineIndex:int = 0
var _currentLine:LineData

var _lineTween : Tween 

#Signal
signal DialogueEnd

func StartDialogue(dialogue:DialogueData) -> void:
	_dialogue = dialogue
	_background.sprite_frames = _dialogue.Background
	_background.play("Default")
	Conductor.Setup(_dialogue.Audio)
	
	_lineIndex = -1
	GetNextLine()

func GetNextLine() -> void:
	_lineIndex += 1
	
	if (_lineIndex < _dialogue.Lines.size()):
		_currentLine = _dialogue.Lines[_lineIndex]
		_dialogueLine.visible_ratio = 0
		_dialogueLine.text = _currentLine.Line
		
		if _currentLine.Character == null:
			_nameBubble.visible = false
			_mainSpeaker.visible = false
			_speaker.visible = false
			
		else:
			_nameBubble.SetSpeaker(_currentLine.Character)
				
			var spritePath = GetEmotion(_currentLine.Character, _currentLine.Emotion)
			match(_currentLine.Location):
				"LEFT":
					if(spritePath != ""):
						_mainSpeaker.texture = load(spritePath)
						_mainSpeaker.visible = true
					else:
						_mainSpeaker.visible = false
					_speaker.visible = false
				"RIGHT":
					if(spritePath != ""):
						_speaker.texture = load(spritePath)
						_speaker.visible = true
					else:
						_speaker.visible = false
					_mainSpeaker.visible = false
				_:
					_mainSpeaker.visible = false
					_speaker.visible = false
		
		_lineTimer.start(_currentLine.NextLine)
		
		_lineTween = create_tween()
		_lineTween.tween_property(_dialogueLine,"visible_ratio", 1, _currentLine.LineDuration)
		
	else:
		# End of Dialogue
		DialogueEnd.emit()
		_lineTimer.stop()
		Reset()
		pass

func Reset() -> void:
	_nameBubble.ClearSpeaker()
	_dialogueLine.text = ""
	_dialogueLine.visible_ratio = 0
	_mainSpeaker.texture = null
	_speaker.texture = null
	
func Skip() -> void:
	GetNextLine()
	
func _on_line_timer_timeout() -> void:
	GetNextLine()

# Helper Functions
func GetEmotion(character:CharacterData, emotion:Enums.Emotions) -> String:
	for emotionSprite in character.Emotions:
		if(emotion == emotionSprite.Emotion):
			return emotionSprite.Sprite
	return ""

func _on_visibility_changed() -> void:
	if visible:
		InputManager.SkipLine.connect(Skip)
	else:
		InputManager.SkipLine.disconnect(Skip)
