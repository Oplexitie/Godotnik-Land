extends Node
class_name GoPhysics

const EPSILON = 0.001
const MAX_RAY_ORIGIN_OVERLAPS = 1

static func cast_ray(world: World2D, origin: Vector2, direction: Vector2, length: float, exclude: Array = [], layer: int = 1) -> Dictionary:
	var destination: Vector2 = origin + direction * length
	var space_state = world.direct_space_state
	
	var ray_params: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.new()
	ray_params.from = origin
	ray_params.to = destination
	ray_params.exclude = exclude
	ray_params.collision_mask = layer
	
	var result: Dictionary = space_state.intersect_ray(ray_params)
	
	var point_params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	point_params.position = origin
	point_params.exclude = exclude
	point_params.collision_mask = layer
	
	var overlaps: Array = space_state.intersect_point(point_params, MAX_RAY_ORIGIN_OVERLAPS)
	
	if result and overlaps.size() == 0:
		var penetration: float = destination.distance_to(result.position)
		return { 'position': result.position, 'normal': result.normal, 'penetration': penetration, 'collider': result.collider }
	
	return {}

static func cast_parallel_rays(world: World2D, origin: Vector2, offset: Vector2, direction: Vector2, length: float, exclude: Array = [], layer: int = 1) -> Dictionary:
	var right_ray: Dictionary = cast_ray(world, origin + offset, direction, length, exclude, layer)
	var left_ray: Dictionary = cast_ray(world, origin - offset, direction, length, exclude, layer)
	
	if right_ray or left_ray:
		var closest_ray: Dictionary = right_ray if right_ray else left_ray
		
		if left_ray and right_ray:
			var right_ray_distance: float = origin.distance_to(right_ray.position)
			var left_ray_distance: float = origin.distance_to(left_ray.position)
			closest_ray = right_ray if right_ray_distance <= left_ray_distance else left_ray
		
		return { 'right_hit': right_ray, 'left_hit': left_ray, 'closest_hit': closest_ray }
	
	return {}

static func overlap_shape(world: World2D, shape: Shape2D, origin: Vector2, rotation: float):
	var space_state = world.direct_space_state
	var params: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas = true
	params.transform = Transform2D(rotation, origin)
	params.set_shape(shape)
	return space_state.intersect_shape(params)
