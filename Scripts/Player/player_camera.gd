extends Camera2D
class_name PlayerCamera

@export var high_velocity_speed: float = 960
@export var low_velocity_speed: float = 360
@export var high_velocity_xsp: float = 480
@export var right_margin: float = 0
@export var left_margin: float = -16
@export var top_margin: float = -32
@export var bottom_margin: float = 32

var player: Player

func _ready():
	initialize_camera()

func _physics_process(delta):
	handle_horizontal_borders(delta)
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

func handle_horizontal_borders(delta: float):
	var target: float = player.get_player_position().x
	
	if target > position.x + right_margin:
		var pos_offset: float = target - position.x - right_margin
		position.x += min(pos_offset, high_velocity_speed * delta)
	
	if target < position.x + left_margin:
		var pos_offset: float = target - position.x - left_margin
		position.x += max(pos_offset, -high_velocity_speed * delta)

func handle_vertical_borders(delta: float):
	var target: float = player.get_player_position().y
	
	if player.is_grounded():
		var is_at_high_velocity: bool = abs(player.velocity.x) >= high_velocity_speed
		var speed: float = low_velocity_speed if is_at_high_velocity else high_velocity_speed
		position.y = lerp(position.y, target, (speed/60) * delta)
	else:
		if target < position.y + top_margin:
			var pos_offset: float = target - position.y - top_margin
			position.y += max(pos_offset, -high_velocity_speed * delta)
		
		if target > position.y + bottom_margin:
			var pos_offset: float = target - position.y - bottom_margin
			position.y += min(pos_offset, high_velocity_speed * delta)

#func _draw():
#	var right = Vector2.RIGHT * right_margin
#	var left = Vector2.RIGHT * left_margin
#	var top_left = Vector2.UP * -top_margin + left
#	var top_right = Vector2.UP * -top_margin + right
#	var bottom_left = Vector2.DOWN * bottom_margin + left
#	var bottom_right = Vector2.DOWN * bottom_margin + right
#	draw_line(top_left, bottom_left, Color.white)
#	draw_line(top_right, bottom_right, Color.white)
#	draw_line(top_left, top_right, Color.white)
#	draw_line(bottom_left, bottom_right, Color.white)
#	draw_line(right, left, Color.green)
