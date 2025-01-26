extends AudioStreamPlayer2D

signal SongPlaying

func PlaySong(audio:AudioStreamMP3) -> void:
	stream = audio
	play()
