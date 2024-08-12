extends AudioPool
class_name SoundEffects

# Used to play sound effects
func play(resource: AudioStreamWAV):
	var player: AudioStreamPlayer = select_player(resource)
	player.call_deferred("play")

# Used to stop all sound effects
func stop():
	for player in audio_players:
		player.call_deferred("stop")
