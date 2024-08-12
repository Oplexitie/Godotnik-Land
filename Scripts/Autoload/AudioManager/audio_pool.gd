extends Node2D
class_name AudioPool

var audio_players: Array[AudioStreamPlayer] = []

# Used to setup de Audio Pools
func _init(audio_bus: String, pool_size : int):
	for i in pool_size:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)
		player.bus = audio_bus
		player.finished.connect(_on_player_finished.bind(player))

# Used to select an unused player or the oldest used one
func select_player(resource: AudioStream):
	for i in audio_players:
		if !i.has_stream_playback() :
			i.stream = resource
			audio_players.append(i)
			audio_players.erase(i)
			return audio_players.back()
	var front_player: AudioStreamPlayer = audio_players.front()
	front_player.stream = resource
	audio_players.append(front_player)
	audio_players.erase(front_player)
	return audio_players.back()

func _on_player_finished(player: AudioStreamPlayer):
	player.stream = null
