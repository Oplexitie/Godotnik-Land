extends Node2D
class_name Particle

@export var animation_name: String = "default"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play():
	visible = true
	animation_player.play(animation_name)

func stop():
	visible = false
	queue_free()

func _on_AnimationPlayer_animation_finished(_anim_name):
	stop()
