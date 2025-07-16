extends AudioPool
class_name PoolSFX

# Used to play sound effects
func play(resource: AudioStreamWAV, volume: float) -> void:
	var player: AudioStreamPlayer = select_player(resource)
	player.volume_db = volume
	player.call_deferred("play")

# Used to stop all sound effects
func stop() -> void:
	for player in audio_players:
		player.stream = null
