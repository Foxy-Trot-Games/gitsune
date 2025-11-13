extends Node

const BACKGROUND_MUSIC_PLAYER = preload("uid://bkcsjsk2ciff")

# Tracks last play time for each sound
var sound_cooldown_times : Dictionary[AudioStream, int] = {}

## wav: sound file to be played[br]
## parent_node: will always be `self`[br]
## sound_cooldown_ms: how often the sound can be played, defaults to 100ms[br]
## volume_db: how loud the sound is, defaults to -10db[br]
## variance: random pitch variance for the sound, defaults to .9 to 1.1 pitch[br]
## max_distance: how far away in pixels the player can hear the sound, defaults to 640 (screen width)[br]
func play_sfx(wav: AudioStreamWAV, parent_node: Node2D, sound_cooldown_ms := 100, volume_db := -10, variance: float = .1, max_distance := 640.0) -> void:
	
	if !wav:
		return
	
	var current_time := Time.get_ticks_msec()
	
	# check if cooldown has happened
	if sound_cooldown_times.has(wav):
		var elapsed := current_time - sound_cooldown_times[wav]
		if elapsed < sound_cooldown_ms:
			return  # don't play since still in cooldown
			
	sound_cooldown_times[wav] = current_time
	
	var audioplayer2d := AudioStreamPlayer2D.new()
	audioplayer2d.position     = parent_node.global_position
	audioplayer2d.bus          = "SFX"
	audioplayer2d.stream       = wav
	audioplayer2d.pitch_scale  = 1.0 + randf_range(-variance, variance)
	audioplayer2d.max_distance = max_distance
	audioplayer2d.attenuation  = 1.0
	audioplayer2d.volume_db = volume_db
	
	audioplayer2d.ready.connect(audioplayer2d.play)
	# clean up node after sfx is done playing
	audioplayer2d.finished.connect(audioplayer2d.queue_free)
	
	# add to level
	Globals.add_child_to_level(audioplayer2d)

func play_bgm(mp3: AudioStreamMP3, volume_db := -15) -> void:
	
	var background_music_player : AudioStreamPlayer = get_tree().get_first_node_in_group("BGMPlayer")
	
	# when running level scenes directly
	if background_music_player == null:
		background_music_player = BACKGROUND_MUSIC_PLAYER.instantiate()
		Globals.add_child_to_level(background_music_player)
	
	background_music_player.stream = mp3
	background_music_player.volume_db = volume_db
	background_music_player.play()
