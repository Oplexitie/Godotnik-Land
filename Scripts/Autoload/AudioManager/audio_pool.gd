extends Node
class_name AudioPool

var audio_players: Array[AudioStreamPlayer] = []

# Used to setup the Audio Pools
func _init(audio_bus: String, size: int) -> void:
	for i in size:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)
		player.bus = audio_bus
		player.finished.connect(on_player_finished.bind(player))

# Used to select an unused player or the oldest used one
func select_player(resource: AudioStream) -> AudioStreamPlayer:
	for player in audio_players:
		if not player.has_stream_playback():
			player.stream = resource
			audio_players.erase(player)
			audio_players.append(player)
			return player
	
	var player: AudioStreamPlayer = audio_players.pop_front()
	player.stream = resource
	audio_players.append(player)
	return player

func on_player_finished(player: AudioStreamPlayer) -> void:
	player.stream = null
