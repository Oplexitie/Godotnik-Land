extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var ring_sparkle = $RingSparkle
@onready var ring_audio: AudioStream = preload("res://Audio/Objects/ring.wav")

func collect(player: Player):
	AudioManager.play_sfx(ring_audio)
	sprite.visible = false
	ring_sparkle.play()
	player.emit_signal("ring_added")
	collider.set_deferred("disabled", true)

func _on_Area2D_area_entered(area):
	var player = area.get_parent()
	
	if player is Player:
		collect(player)

func _on_AnimationPlayer_animation_finished(_anim_name):
	visible = false
	queue_free()
