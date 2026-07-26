# running_state.gd
extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.state_label.text = "Runnning"

func physics_update(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# 1. Check if we should transition back to Idle
	if direction == Vector2.ZERO:
		finished.emit(IDLE, {})
		return
		
	# 2. Calculate movement
	var speed := player.RUN_SPEED if Input.is_action_pressed("sprint") else player.WALK_SPEED
	player.velocity = direction * speed
	
	# 3. Handle visual flipping
	if direction.x != 0:
		player.sprite_2d.flip_h = (direction.x < 0)
		
	# 4. Handle actions that can occur while moving
	if Input.is_action_just_pressed("action"):
		player.low_res_camera.camera_shake(0.6)
		
	# 5. Apply physics
	player.move_and_slide()
	player.global_position = player.global_position.round()
