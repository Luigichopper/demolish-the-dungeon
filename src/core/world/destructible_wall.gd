# res://src/core/world/destructible_wall.gd
extends TileMapLayer

@export var crack_texture: Texture2D
@export var debris_scene: PackedScene = preload("res://src/core/effects/tile_debris.tscn")

var damaged_tiles: Array[Vector2i] = []

func damage_tile(map_coord: Vector2i) -> void:
	var tile_data := get_cell_tile_data(map_coord)
	if not tile_data or not tile_data.get_custom_data("is_destructible"):
		return

	# Mark tile as damaged if it isn't already
	if not damaged_tiles.has(map_coord):
		damaged_tiles.append(map_coord)
		queue_redraw()
	else:
		destroy_tile(map_coord)


func destroy_tile(map_coord: Vector2i) -> void:
	# Clear damage tracking and remove the tile
	_spawn_debris(map_coord)
	damaged_tiles.erase(map_coord)
	set_cells_terrain_connect([map_coord], 0, -1, true)
	queue_redraw()


func _draw() -> void:
	if not crack_texture:
		return

	var tile_offset := Vector2(tile_set.tile_size) / 2.0

	for coord: Vector2i in damaged_tiles:
		# Convert map coordinate to top-left pixel pos of a standard 16x16 cell
		var local_pos := map_to_local(coord) - tile_offset
		
		# Offset Y downward by 8px and force destination height to 32px (16x32)
		var crack_pos := local_pos + Vector2(0, -8)
		var dest_rect := Rect2(crack_pos, Vector2(16, 32))
		
		# Draw the 16x32 crack overlay texture without squashing
		draw_texture_rect(crack_texture, dest_rect, false)

func _spawn_debris(map_coord: Vector2i) -> void:
	if debris_scene == null:
		return
	
	var debris := debris_scene.instantiate() as GPUParticles2D
	debris.global_position = to_global(map_to_local(map_coord))
	
	var container: Node = get_tree().root.find_child("LowResGame", true, false)
	if not container:
		container = get_parent()
	container.add_child(debris)
	debris.restart()
