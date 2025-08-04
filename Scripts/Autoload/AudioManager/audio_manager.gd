extends Node

var audio_music: PoolBGM = PoolBGM.new("Music", 1)
var audio_sfx: PoolSFX = PoolSFX.new("SFX", 4)

func _ready() -> void:
	add_child(audio_sfx)
	add_child(audio_music)

# Sound Effects
func play_sfx(resource: AudioStreamWAV, volume_db: float = 0.0) -> void:
	audio_sfx.play(resource,volume_db)

func stop_sfx() -> void:
	audio_sfx.stop()

# Music
func play_music(resource: AudioStreamOggVorbis, volume_db: float = 0.0) -> void:
	audio_music.play(resource,volume_db)

func stop_music() -> void:
	audio_music.stop()

func pause_music() -> void:
	audio_music.pause()

func resume_music() -> void:
	audio_music.resume()

func fade_music(to_volume: float, duration: float) -> void:
	audio_music.fade_music(to_volume,duration)

# Audio Bus
func set_bus(bus_id: int, volume_db: float) -> void:
	AudioServer.set_bus_volume_db(bus_id,volume_db)

func muting_bus(bus_id: int, is_mute: bool) -> void:
	AudioServer.set_bus_mute(bus_id, is_mute)
