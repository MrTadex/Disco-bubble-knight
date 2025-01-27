extends AudioStreamPlayer

@export var bpm := 100
@export var measures := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

# Input signals
signal s_beat(position)
signal s_measure(position)

@export var countBeats = false

func Setup(Audio:AudioStreamMP3, BPM:float = 100, Measures:float = 4, CountBeats:bool = false, BeatOffset:int = 0) -> void:
	stream = Audio
	bpm = BPM
	measures = Measures
	countBeats = CountBeats
	
	Reset()
	
	if CountBeats:
		play_with_beat_offset(BeatOffset)
	else:
		play()
		
func Reset() -> void:
	song_position = 0.0
	song_position_in_beats = 1
	sec_per_beat = 60.0 / bpm
	last_reported_beat = 0
	beats_before_start = 0
	measure = 1
	
func _physics_process(_delta):
	
	if playing and countBeats:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("s_beat", song_position_in_beats)
		emit_signal("s_measure", measure)
		measure += 1
	last_reported_beat = song_position_in_beats

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat, offset):
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures
	play()

func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
