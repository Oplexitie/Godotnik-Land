extends Node2D

@export var item_effect: ItemEffects
@export var particle_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D

func collect(player: Player) -> void:
	item_effect.execute(player)
	
	var particle: Particle = particle_scene.instantiate()
	particle.global_position = global_position
	add_sibling(particle)
	particle.play()
	
	sprite.visible = false
	collider.set_deferred("disabled", true)
	queue_free()

func _on_Area2D_area_entered(area) -> void:
	var player: Variant = area.get_parent()
	if player is Player:
		collect(player)
