extends Node2D
class_name Player

signal ground_enter

@export var bounds: Array[Resource]
@export var stats: Array[Resource]

@export_flags_2d_physics var wall_layer: int = 1
@export_flags_2d_physics var ground_layer: int = 1
@export_flags_2d_physics var ceiling_layer: int = 1

@onready var skin = $Skin as PlayerSkin
@onready var state_machine = $StateMachine as PlayerStateMachine
@onready var shields = $Shields as ShieldsManager
@onready var audios = $Audios as PlayerAudio


@onready var initial_parent = get_parent()

var world: World2D
var current_bounds: PlayerCollision
var current_stats: PlayerStats

var collider: Area2D
var collider_shape: RectangleShape2D

var velocity: Vector2
var ground_normal: Vector2
var input_direction: Vector2

var ground_angle: float
var absolute_ground_angle: float
var input_dot_velocity: float
var control_lock_timer: float

var limit_left: float
var limit_right: float

var is_jumping: bool
var is_rolling: bool
var is_control_locked: bool
var is_locked_to_limits: bool

var __is_grounded: bool
var is_pushing: bool

var isnt_grounded_left: bool
var isnt_grounded_right: bool
var isnt_grounded_center: bool

var last_rotation: float

func _ready():
	initialize_collider()
	initialize_resources()
	initialize_state_machine()
	initialize_skin()

func _physics_process(delta):
	handle_input()
	handle_control_lock(delta)
	handle_state_update(delta)
	handle_motion(delta)
	handle_limits()
	handle_state_animation(delta)
	handle_skin(delta)

func initialize_collider():
	var collision: CollisionShape2D = CollisionShape2D.new()
	collider_shape = RectangleShape2D.new()
	collider = Area2D.new()
	collision.shape = collider_shape
	collider.add_child(collision)
	add_child(collider)

func initialize_resources():
	world = get_world_2d()
	set_bounds(0)
	set_stats(0)

func initialize_state_machine():
	state_machine.initialize()

func initialize_skin():
	remove_child(skin)
	get_parent().call_deferred("add_child", skin)

func get_player_position():
	return global_position + current_bounds.offset

func set_bounds(index: int):
	if index >= 0 and index < bounds.size():
		var last_bounds: PlayerCollision = current_bounds
		current_bounds = bounds[index]
		collider_shape.extents.x = current_bounds.width_radius + current_bounds.push_radius
		collider_shape.extents.y = current_bounds.height_radius
		
		if last_bounds and last_bounds != current_bounds:
			position += last_bounds.offset

func set_stats(index: int):
	if index >= 0 and index < bounds.size():
		current_stats = stats[index]

func is_grounded():
	return __is_grounded and velocity.y >= 0

func handle_state_update(delta: float):
	state_machine.update_state(delta)

func handle_motion(delta: float):
	var offset: float = velocity.length() * delta
	var max_motion_size: float = current_bounds.width_radius
	var motion_steps: float = ceil(offset / max_motion_size)
	var step_motion: Vector2 = velocity / motion_steps
	
	while motion_steps > 0:
		apply_motion(step_motion, delta)
		handle_collision()
		motion_steps -= 1

func handle_collision():
	handle_wall_collision()
	handle_ground_collision()
	handle_ceiling_collision()

func handle_limits():
	if is_locked_to_limits:
		var offset: float = current_bounds.width_radius
		if global_position.x + offset > limit_right:
			global_position.x = limit_right - offset
			velocity.x = 0
		if global_position.x - offset < limit_left:
			global_position.x = limit_left + offset
			velocity.x = 0

func handle_state_animation(delta):
	state_machine.animate_state(delta)

func handle_skin(delta):
	skin.position = global_position
	
	var target_angle: float = 0
	var rotation_speed: float = skin.AIR_ROTATION_SPEED
	
	if __is_grounded:
		rotation_speed = skin.GROUND_ROTATION_SPEED
		if absolute_ground_angle > 23:
			target_angle = GoUtils.get_radian_from(ground_normal)
	
	if not is_rolling:
		target_angle = lerp_angle(last_rotation, target_angle, rotation_speed * delta)
		skin.rotation = target_angle
	
	last_rotation = target_angle

func handle_wall_collision():
	var ray_size: float = current_bounds.width_radius + current_bounds.push_radius
	var origin: Vector2 = global_position + transform.y * current_bounds.push_height_offset if __is_grounded and absolute_ground_angle < 10 else global_position
	var right_ray: Dictionary = GoPhysics.cast_ray(world, origin, transform.x, ray_size, [self], wall_layer)
	var left_ray: Dictionary = GoPhysics.cast_ray(world, origin, -transform.x, ray_size, [self], wall_layer)
	
	if right_ray or left_ray:
		is_pushing = true
		if right_ray:
			handle_contact(right_ray.collider, "player_right_wall_collision")
			
			if not right_ray.collider is SolidObject or right_ray.collider.is_enabled():
				velocity.x = min(velocity.x, 0)
				position -= transform.x * (right_ray.penetration + GoPhysics.EPSILON)
		
		if left_ray:
			handle_contact(left_ray.collider, "player_left_wall_collision")
			
			if not left_ray.collider is SolidObject or left_ray.collider.is_enabled():
				velocity.x = max(velocity.x, 0)
				position += transform.x * (left_ray.penetration + GoPhysics.EPSILON)
	else:
		is_pushing = false

func handle_ceiling_collision():
	var ray_size: float = current_bounds.height_radius
	var ray_offset: Vector2 = transform.x * current_bounds.width_radius
	var hits: Dictionary = GoPhysics.cast_parallel_rays(world, global_position, ray_offset, -transform.y, ray_size, [self], ceiling_layer)
	
	if hits:
		handle_contact(hits.closest_hit.collider, "player_ceiling_collision")
		
		if not __is_grounded and (not hits.closest_hit.collider is SolidObject or hits.closest_hit.collider.is_enabled()):
			var ceiling_normal: Vector2 = hits.closest_hit.normal
			var ceiling_angle: float = GoUtils.get_angle_from(ceiling_normal)
			
			if velocity.y < 0:
				if abs(ceiling_angle) < 135:
					set_ground_data(ceiling_normal)
					rotate_to(ceiling_angle)
					enter_ground(hits.closest_hit)
				else:
					velocity.y = 0
		
			position += transform.y * hits.closest_hit.penetration

func handle_ground_collision():
	var ray_offset: Vector2 = transform.x * current_bounds.width_radius
	var ray_size: float = current_bounds.height_radius + current_bounds.ground_extension if __is_grounded else current_bounds.height_radius
	var hits: Dictionary = GoPhysics.cast_parallel_rays(world, global_position, ray_offset, transform.y, ray_size, [self], ground_layer)
	
	if hits and velocity.y >= 0:
		handle_contact(hits.closest_hit.collider, "player_ground_collision")
		
		if not hits.closest_hit.collider is SolidObject or hits.closest_hit.collider.is_enabled():
			isnt_grounded_center = GoPhysics.cast_ray(world, global_position, transform.y, ray_size, [self], ground_layer).is_empty()
			
			if not __is_grounded and velocity.y >= 0:
				set_ground_data(hits.closest_hit.normal)
				rotate_to(ground_angle)
				position -= transform.y * hits.closest_hit.penetration
				enter_ground(hits.closest_hit)
			elif hits.left_hit or hits.right_hit:
				isnt_grounded_left = hits.left_hit.is_empty()
				isnt_grounded_right = hits.right_hit.is_empty()
				
				var safe_distance: float = hits.closest_hit.penetration - current_bounds.ground_extension
				set_ground_data(hits.closest_hit.normal)
				rotate_to(ground_angle)
				position -= transform.y * safe_distance
	else:
		exit_ground()

func handle_contact(static_body: Object, signal_name: String):
	if static_body is SolidObject:
		static_body.emit_signal(signal_name, self)

func handle_platform(platform_collider: Object):
	if __is_grounded and platform_collider is MovingPlatform:
		reparent_player(platform_collider)
	else:
		reparent_player(initial_parent)

func apply_motion(desired_velocity: Vector2, delta: float):
	if __is_grounded:
		var global_velocity: Vector2 = GoUtils.ground_to_global_velocity(desired_velocity, ground_normal)
		position += global_velocity * delta
	else:
		position += desired_velocity * delta

func set_ground_data(normal: Vector2 = Vector2.UP):
	ground_normal = normal
	ground_angle = GoUtils.get_angle_from(normal)
	absolute_ground_angle = abs(ground_angle)

func rotate_to(angle: float):
	var closest_angle: int = snapped(angle, 90)
	rotation_degrees = closest_angle

func handle_input():
	var horizontal: float = Input.get_axis("player_left", "player_right")
	var vertical: float = Input.get_axis("player_down", "player_up")
	if __is_grounded:
		horizontal = 0.0 if is_control_locked else horizontal
	input_direction = Vector2(horizontal, vertical)
	input_dot_velocity = input_direction.dot(velocity)

func lock_controls(lock_duration: float):
	if not is_control_locked:
		input_direction.x = 0
		is_control_locked = true
		control_lock_timer = lock_duration

func unlock_controls():
	if is_control_locked:
		is_control_locked = false
		control_lock_timer = 0

func handle_control_lock(delta: float):
	if is_control_locked:
		control_lock_timer -= delta
		if abs(velocity.x) == 0 or control_lock_timer <= 0:
			unlock_controls()

func handle_fall():
	if __is_grounded and absolute_ground_angle > current_stats.slide_angle and abs(velocity.x) <= current_stats.min_speed_to_fall:
		lock_controls(current_stats.CONTROL_LOCK_DURATION)

		if absolute_ground_angle > current_stats.fall_angle:
			exit_ground()

func handle_slope(delta: float):
	if __is_grounded:
		var down_hill: bool = velocity.dot(ground_normal) > 0
		var rolling_factor: float = current_stats.slope_roll_down if down_hill else current_stats.slope_roll_up
		var amount: float = rolling_factor if is_rolling else current_stats.slope_factor
		velocity.x += amount * ground_normal.x * delta

func handle_gravity(delta: float):
	if not __is_grounded:
		velocity.y += current_stats.gravity * delta

func handle_acceleration(delta: float):
	if input_direction.x != 0:
		if sign(input_direction.x) == sign(velocity.x) or not __is_grounded:
			var amount: float = current_stats.acceleration if __is_grounded else current_stats.air_acceleration
			if abs(velocity.x) < current_stats.top_speed:
				velocity.x += input_direction.x * amount * delta
				velocity.x = clamp(velocity.x, -current_stats.top_speed, current_stats.top_speed)
		else:
			velocity.x += input_direction.x * current_stats.deceleration * delta

func handle_deceleration(delta: float):
	if input_direction.x != 0 and sign(input_direction.x) != sign(velocity.x):
		var amount: float = current_stats.roll_deceleration if is_rolling else current_stats.deceleration
		velocity.x = move_toward(velocity.x, 0, amount * delta)

func handle_friction(delta: float):
	if __is_grounded and (input_direction.x == 0 or is_rolling):
		var amount: float = current_stats.roll_friction if is_rolling else current_stats.friction
		velocity.x = move_toward(velocity.x, 0, amount * delta)

func handle_jump():
	if __is_grounded and Input.is_action_just_pressed("player_a"):
		is_jumping = true
		is_rolling = true
		AudioManager.play_sfx(audios.jump_audio)
		velocity.y = -current_stats.max_jump_height

	if is_jumping and Input.is_action_just_released("player_a") and velocity.y < -current_stats.min_jump_height:
		velocity.y = -current_stats.min_jump_height

func lock_to_limits(left: float, right: float):
	limit_left = left
	limit_right = right
	is_locked_to_limits = true

func reparent_player(new_parent: Node):
	var current_parent = get_parent()
	if new_parent != current_parent:
		var old_transform = global_transform
		current_parent.remove_child(self)
		new_parent.add_child(self)
		global_transform = old_transform

func enter_ground(ground_data: Dictionary):
	if not __is_grounded:
		is_jumping = false
		is_rolling = false
		__is_grounded = true
		velocity = GoUtils.global_to_ground_velocity(velocity, ground_normal)
		handle_platform(ground_data.collider)
		emit_signal("ground_enter")

func exit_ground():
	if __is_grounded:
		__is_grounded = false
		reparent_player(initial_parent)
		velocity = GoUtils.ground_to_global_velocity(velocity, ground_normal)
		rotate_to(0)

#func _draw():
#	var ground_ray_size = current_bounds.height_radius + current_bounds.ground_extension if __is_grounded else current_bounds.height_radius
#	var horizontal_origin = Vector2.ZERO - Vector2.UP * current_bounds.push_height_offset if __is_grounded and absolute_ground_angle < 1 else Vector2.ZERO
#
#	draw_line(horizontal_origin, horizontal_origin + Vector2.RIGHT * (current_bounds.width_radius + current_bounds.push_radius), Color.crimson)
#	draw_line(horizontal_origin, horizontal_origin - Vector2.RIGHT * (current_bounds.width_radius + current_bounds.push_radius), Color.hotpink)
#	draw_line(Vector2.RIGHT * current_bounds.width_radius, Vector2.RIGHT * current_bounds.width_radius - Vector2.UP * ground_ray_size, Color.cyan)
#	draw_line(-Vector2.RIGHT * current_bounds.width_radius, -Vector2.RIGHT * current_bounds.width_radius - Vector2.UP * ground_ray_size, Color.green)
#	draw_line(Vector2.RIGHT * current_bounds.width_radius, Vector2.RIGHT * current_bounds.width_radius + Vector2.UP * current_bounds.height_radius, Color.yellow)
#	draw_line(-Vector2.RIGHT * current_bounds.width_radius, -Vector2.RIGHT * current_bounds.width_radius + Vector2.UP * current_bounds.height_radius, Color.blue)
