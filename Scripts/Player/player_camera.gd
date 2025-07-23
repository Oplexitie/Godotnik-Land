extends Camera2D
class_name PlayerCamera

const FULL_V_MARGIN: float = 64
const V_MARGIN: float = 32
const H_MARGIN: float = 16

@export var speed: float = 6

var player: Player
var cam_drag_lerp: float = 0

@onready var viewSize: Vector2i = get_viewport_rect().size

func _ready() -> void:
	initialize_camera()
	
	drag_right_margin = H_MARGIN / viewSize.x
	drag_left_margin= H_MARGIN / viewSize.x

func _physics_process(delta) -> void:
	position = player.get_player_position()
	handle_vertical_borders(delta)

func initialize_camera() -> void:
	enabled = true

func set_player(desired_player: Player) -> void:
	player = desired_player
	position = player.global_position

func set_limits(left: int, right: int, top: int, bottom: int) -> void:
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom

func handle_vertical_borders(delta: float) -> void:
	var cam_offset: float = ((abs(position.y - get_target_position().y)) / V_MARGIN)
	var not_grounded: int = 1 if !player.is_grounded() else 0
	cam_drag_lerp = max(not_grounded, min(cam_drag_lerp, cam_offset) - speed * delta)
	
	drag_top_margin = lerp(0.0, FULL_V_MARGIN / viewSize.y, cam_drag_lerp)
	drag_bottom_margin = drag_top_margin
