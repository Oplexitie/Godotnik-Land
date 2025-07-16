extends AudioPool
class_name PoolBGM

var tween: Tween

# Used to play music
func play(resource: AudioStreamOggVorbis, volume: float) -> void:
	var player: AudioStreamPlayer = select_player(resource)
	player.volume_db = volume
	player.call_deferred("play")

# Used to stop the music
func stop() -> void:
	on_player_finished(audio_players.front())

# Used to pause the music
func pause() -> void:
	audio_players.front().stream_paused = true

# Used to resume the music if it was paused
func resume() -> void:
	audio_players.front().stream_paused = false

# Used to make fade in/out's with the music
func fade_music(to_volume: float, duration: float) -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(audio_players.front(), "volume_db", to_volume, duration)
