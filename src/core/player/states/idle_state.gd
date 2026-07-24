# idle_state.gd
extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.state_label.text = "Idle"
	# Ensure the player comes to a complete stop when entering Idle
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	# 1. Check for state transitions first
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		finished.emit(RUNNING, {})
		return
		
	# 2. Handle actions that can occur while idle
	if Input.is_action_just_pressed("action"):
		player.low_res_camera.camera_shake(0.6)
		
	# 3. Apply physics (we still call this in idle in case of external forces like knockback)
	player.move_and_slide()
	player.global_position = player.global_position.round()
