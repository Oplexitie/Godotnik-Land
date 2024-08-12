extends Node2D
class_name Monitor

const BUMP_FORCE: int = 150
const GRAVITY: int = 700
const GROUND_DISTANCE: int = 16

@export_enum("BlueShield", "ThunderShield", "FlameShield", "BubbleShield") var shield_type: String
@export var jingle_audio: AudioStream
@export var score: int
@export var rings: int
@export var lives: int
@export_flags_2d_physics var ground_layer: int = 1

@onready var tree = get_tree()
@onready var world = get_world_2d()
@onready var icon: Sprite2D = $Icon
@onready var explosion: Sprite2D = $Explosion0
@onready var explosion_audio: AudioStream = preload("res://Audio/Objects/explosion.wav")
@onready var solid_object: StaticBody2D = $SolidObject
@onready var animation_player: AnimationPlayer = $Sprite/AnimationPlayer
@onready var animation_tree: AnimationTree = $Sprite/AnimationTree

var velocity: Vector2
var allow_movement: bool

func _physics_process(delta):
	if allow_movement:
		handle_movement(delta)
		handle_collision()

func handle_movement(delta: float):
	velocity.y += GRAVITY * delta
	position += velocity * delta

func handle_collision():
	var ground_hit = GoPhysics.cast_ray(world, position, transform.y, 
		GROUND_DISTANCE, [solid_object], ground_layer)
	
	if ground_hit:
		allow_movement = false
		velocity = Vector2.ZERO
		position.y -= ground_hit.penetration
		position = position.round()

func destroy():
	explosion.play()
	icon.set_movement(true)
	AudioManager.play_sfx(explosion_audio)
	solid_object.set_enabled(false)
	animation_tree.set("parameters/state/transition_request", 1)

func handle_item(player : Player):
	destroy()
	await tree.create_timer(0.5).timeout
	
	AudioManager.play_sfx(jingle_audio)
	ScoreManager.add_score(score)
	ScoreManager.add_ring(rings)
	ScoreManager.add_life(lives)
	
	if(shield_type): player.shields.change(shield_type)
	
	animation_tree.queue_free()
	animation_player.queue_free()

func bump_up():
	allow_movement = true
	velocity.y = -BUMP_FORCE

func _on_SolidObject_player_ceiling_collision(player: Player):
	if player.velocity.y <= 0:
		bump_up()

func _on_SolidObject_player_ground_collision(player: Player):
	if player.is_rolling and player.velocity.y > 0:
		player.velocity.y = -player.velocity.y
		player.shields.cancel_current()
		handle_item(player)

func _on_SolidObject_player_wall_collision(player: Player):
	if player.is_grounded() and player.is_rolling:
		handle_item(player)
