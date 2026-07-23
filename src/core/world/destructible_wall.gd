# res://src/core/world/destructible_wall.gd
extends TileMapLayer

const WALL_TERRAIN_SET := 0
const WALL_TERRAIN := 0

@export var debris_scene: PackedScene = preload("res://src/core/effects/tile_debris.tscn")

func destroy_tile(map_coord: Vector2i) -> void:
	_spawn_debris(map_coord)
	erase_cell(map_coord)
	
	# Update neighboring tiles
	var neighbors: Array[Vector2i] = []
	for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT,
			Vector2i(1,1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(-1,-1)]:
		var n = map_coord + dir
		if get_cell_source_id(n) != -1:
			neighbors.append(n)
	if not neighbors.is_empty():
		set_cells_terrain_connect(neighbors, WALL_TERRAIN_SET, WALL_TERRAIN, true)


func _spawn_debris(map_coord: Vector2i) -> void:
	if debris_scene == null:
		return
	
	# Prepare debris effect instance
	var debris := debris_scene.instantiate() as GPUParticles2D
	debris.global_position = to_global(map_to_local(map_coord))
	
	# Instatiate effect in correct container
	var container: Node = get_tree().root.find_child("LowResGame", true, false)
	if not container:
		container = get_parent()
	container.add_child(debris)
	debris.restart()
