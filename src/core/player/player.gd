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
	
	# Action calling
	if Input.is_action_just_pressed("action") == true:
		return
	
	move_and_slide()
	
	global_position = global_position.round()
