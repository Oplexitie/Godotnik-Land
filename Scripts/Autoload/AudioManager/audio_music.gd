extends AudioPool
class_name SoundMusic

var music_tween: Tween

# Used to play music
func play(resource: AudioStreamOggVorbis):
	var player: AudioStreamPlayer = select_player(resource)
	player.call_deferred("play")

# Used to stop the music
func stop():
	audio_players.front().call_deferred("stop")

func fade_music(to_volume: float, duration: float):
	if music_tween: music_tween.kill()
	music_tween = create_tween()
	music_tween.tween_property(audio_players.front(), "volume_db", to_volume, duration)
