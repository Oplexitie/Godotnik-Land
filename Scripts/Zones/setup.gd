extends Node2D
class_name Zone

@export var player_resource: PackedScene
@export var camera_resource: PackedScene
@export var hud_resource: PackedScene

@export var limit_left: int = 0
@export var limit_right: int = 10000
@export var limit_top: int = 0
@export var limit_bottom: int = 10000

@onready var start_point: Node2D = $Level/StartPoint

var player: Player
var camera: PlayerCamera

func _ready():
	initialize_player()
	initialize_camera()
	initialize_hud()

func initialize_player():
	player = player_resource.instantiate()
	player.position = start_point.position
	player.lock_to_limits(limit_left, limit_right)
	add_child(player)

func initialize_camera():
	camera = camera_resource.instantiate()
	camera.set_player(player)
	camera.set_limits(limit_left, limit_right, limit_top, limit_bottom)
	add_child(camera)

func initialize_hud():
	var hud = hud_resource.instantiate()
	add_child(hud)
