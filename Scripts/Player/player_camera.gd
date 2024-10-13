extends Camera2D
class_name PlayerCamera

const FULL_V_MARGIN: float = 64
const V_MARGIN: float = 32
const H_MARGIN: float = 16

@export var speed: float = 6

@onready var viewSize: Vector2i = get_viewport_rect().size

var player: Player
var cam_drag_lerp: float = 0

func _ready():
	initialize_camera()
	
	drag_right_margin = H_MARGIN / viewSize.x
	drag_left_margin= H_MARGIN / viewSize.x

func _physics_process(delta):
	position = player.get_player_position()
	handle_vertical_borders(delta)

func initialize_camera():
	enabled = true

func set_player(desired_player: Player):
	player = desired_player
	position = player.global_position

func set_limits(left: int, right: int, top: int, bottom: int):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom

func handle_vertical_borders(delta: float):
	var cam_offset = ((abs(position.y - get_target_position().y)) / V_MARGIN)
	var not_grounded = 1 if !player.is_grounded() else 0
	cam_drag_lerp = max(not_grounded, min(cam_drag_lerp, cam_offset) - speed * delta)
	
	drag_top_margin = lerp(0.0, FULL_V_MARGIN / viewSize.y, cam_drag_lerp)
	drag_bottom_margin = drag_top_margin
