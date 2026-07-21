# res://src/core/player/player.gd
extends CharacterBody2D

const WALK_SPEED: float = 80.0
const RUN_SPEED: float = 100.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	var speed := RUN_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED
	
	velocity = direction * WALK_SPEED
	
	move_and_slide()
	
	global_position = global_position.round()
