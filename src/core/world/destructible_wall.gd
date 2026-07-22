# res://src/core/world/destructible_wall.gd
extends TileMapLayer

# Call this from your player's attack script or bomb explosion
func destroy_tile_at_world_position(world_position: Vector2) -> bool:
	# 1. Convert pixel position (world space) into tile grid coordinates (e.g., Vector2i(4, 12))
	var map_coord: Vector2i = local_to_map(world_position)
	
	# 2. Get the tile data at those coordinates
	var tile_data: TileData = get_cell_tile_data(map_coord)
	
	# If there's no tile here, do nothing
	if tile_data == null:
		return false
		
	# 3. Check if this tile has the "is_destructible" custom data tag set to true
	var can_destroy: bool = tile_data.get_custom_data("is_destructible")
	
	if can_destroy:
		set_cells_terrain_connect([map_coord], 0, -1, true)
		
		# Optional: Spawn debris particles or sound effect here
		# spawn_debris_effect(map_coord)
		return true
		
	return false
