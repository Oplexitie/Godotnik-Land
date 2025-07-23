extends Area2D
class_name PlayerLayerController

@export_flags_2d_physics var wall_layer: int = 1
@export_flags_2d_physics var ground_layer: int = 1
@export_flags_2d_physics var ceiling_layer: int = 1

func _on_Area2D_area_entered(area):
	var player: Variant = area.get_parent()
	
	if player is Player:
		player.wall_layer = wall_layer
		player.ground_layer = ground_layer
		player.ceiling_layer = ceiling_layer
