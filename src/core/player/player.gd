# res://src/core/player/player.gd
extends CharacterBody2D

const WALK_SPEED: float = 80.0
const RUN_SPEED: float = 100.0

@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var speed := RUN_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED
	
	velocity = direction * speed
	
	# Sprite flipping
	if direction.x != 0:
		sprite_2d.flip_h = (direction.x < 0)
	
	# Perform standard movement & collisions
	move_and_slide()
	
	# Check for wall collisions during the move
	_handle_wall_destruction()
	
	global_position = global_position.round()

func _handle_wall_destruction() -> void:
	# Iterate over every collision that occurred during move_and_slide()
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Check if the object we bumped into is a TileMapLayer
		if collider is TileMapLayer:
			var tilemap_layer: TileMapLayer = collider
			
			# Nudge collision position slightly along normal into the tile space
			var hit_point: Vector2 = collision.get_position() - (collision.get_normal() * 4.0)
			var map_coord: Vector2i = tilemap_layer.local_to_map(hit_point)
			
			var tile_data: TileData = tilemap_layer.get_cell_tile_data(map_coord)
			
			# If the tile has 'is_destructible' checked, destroy it
			if tile_data and tile_data.get_custom_data("is_destructible"):
				# Updates neighboring autotile bitmasks if you use Terrains
				tilemap_layer.set_cells_terrain_connect([map_coord], 0, -1, true)
