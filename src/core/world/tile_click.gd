# res://src/core/interaction/tile_click_damager.gd
extends Node2D

@export var tile_map_layer: TileMapLayer

func _unhandled_input(event: InputEvent) -> void:
	if not tile_map_layer:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_process_tile_click()

func _process_tile_click() -> void:
	# Add 8px to Y so clicking targets the lower half of the 16x32 tile
	var mouse_global_pos := get_global_mouse_position() + Vector2(0, -8)
	var click_coord := tile_map_layer.local_to_map(tile_map_layer.to_local(mouse_global_pos))

	var source_id := tile_map_layer.get_cell_source_id(click_coord)
	if source_id == -1:
		return # Empty space clicked

	if tile_map_layer.damaged_tiles.has(click_coord):
		tile_map_layer.destroy_tile(click_coord)
	else:
		tile_map_layer.damage_tile(click_coord)
