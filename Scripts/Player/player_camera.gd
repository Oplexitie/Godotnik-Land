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
	var offset = ((abs(position.y - get_target_position().y)) / V_MARGIN)
	var not_grounded = 1 if !player.is_grounded() else 0
	cam_drag_lerp = max(not_grounded, min(cam_drag_lerp, offset) - speed * delta)
	
	drag_top_margin = lerp(0.0, FULL_V_MARGIN / viewSize.y, cam_drag_lerp)	
	drag_bottom_margin = drag_top_margin
	
#func _draw():
	#var right = Vector2.RIGHT * drag_right_margin
	#var left = Vector2.RIGHT * drag_left_margin
	#var top_left = Vector2.UP * -drag_top_margin + left
	#var top_right = Vector2.UP * -drag_top_margin + right
	#var bottom_left = Vector2.DOWN * drag_bottom_margin + left
	#var bottom_right = Vector2.DOWN * drag_bottom_margin + right
	#draw_line(top_left, bottom_left, Color.WHITE)
	#draw_line(top_right, bottom_right, Color.WHITE)
	#draw_line(top_left, top_right, Color.WHITE)
	#draw_line(bottom_left, bottom_right, Color.WHITE)
	#draw_line(right, left, Color.WHITE)
