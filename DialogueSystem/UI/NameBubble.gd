extends Node

@onready var _characterIcon := %CharacterIcon
@onready var _characterName := %CharacterName

func SetSpeaker(character: CharacterData) -> void:
	_characterIcon.texture = load(character.IconPath)
	_characterName.text = character.Name

func ClearSpeaker() -> void:
	_characterIcon.texture = null
	_characterName.text = ""
