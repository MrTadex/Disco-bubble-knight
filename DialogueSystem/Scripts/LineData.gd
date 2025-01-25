extends Resource

class_name LineData

@export var Character: CharacterData
@export_enum("LEFT", "RIGHT") var Location:String = "LEFT"
@export_multiline var Line: String
@export var Emotion : Enums.Emotions
@export var LineDuration: float = 4
@export var NextLine: float = 5
