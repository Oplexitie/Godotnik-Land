extends Node2D
class_name Monitor

const BUMP_FORCE: int = 150
const GRAVITY: int = 700
const GROUND_DISTANCE: int = 16

@export var item_effect: ItemEffects
@export var particle_offset: Vector2 = Vector2(0,-4)
@export_flags_2d_physics var ground_layer: int = 1

var velocity: Vector2
var allow_movement: bool

@onready var world: World2D = get_world_2d()
@onready var icon: Sprite2D = $Icon
@onready var solid_object: StaticBody2D = $SolidObject
@onready var animation_tree: AnimationTree = $Sprite/AnimationTree
@onready var explosion: PackedScene = preload("uid://b72awigk0020g")
@onready var explosion_audio: AudioStream = preload("res://Audio/Objects/explosion.wav")

func _physics_process(delta) -> void:
	if allow_movement:
		handle_movement(delta)
		handle_collision()

func handle_movement(delta: float) -> void:
	velocity.y += GRAVITY * delta
	position += velocity * delta

func handle_collision() -> void:
	var ground_hit: Dictionary = GoPhysics.cast_ray(world, position, transform.y, 
		GROUND_DISTANCE, [solid_object], ground_layer)
	
	if ground_hit:
		allow_movement = false
		velocity = Vector2.ZERO
		position.y -= ground_hit.penetration
		position = position.round()

func handle_item(player: Player) -> void:
	destroy()
	await icon.move_tween.finished
	item_effect.execute(player)

func destroy():
	AudioManager.play_sfx(explosion_audio)
	
	var particle: Particle = explosion.instantiate()
	particle.global_position = global_position + particle_offset
	add_sibling(particle)
	particle.play()
	
	icon.start_movement()
	solid_object.set_enabled(false)
	animation_tree.set("parameters/state/transition_request", 1)

func bump_up() -> void:
	allow_movement = true
	velocity.y = -BUMP_FORCE

func _on_SolidObject_player_ceiling_collision(player: Player) -> void:
	if player.velocity.y <= 0:
		bump_up()

func _on_SolidObject_player_ground_collision(player: Player) -> void:
	if player.is_rolling and player.velocity.y > 0:
		player.velocity.y = -player.velocity.y
		player.shields.cancel_current()
		handle_item(player)

func _on_SolidObject_player_wall_collision(player: Player) -> void:
	if player.is_grounded() and player.is_rolling:
		handle_item(player)
