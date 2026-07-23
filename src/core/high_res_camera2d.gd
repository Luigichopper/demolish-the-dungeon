# high_res_camera2d.gd
extends Camera2D

# Basic variables
@export var player: CharacterBody2D
@export var sub_viewport_container: SubViewportContainer
@export var smooth_speed := 3.0
@export var velocity_influence := 0.2

# Camera shake variables
@export var max_shake_offset := Vector2(40, 30)    # px
@export var max_shake_roll := deg_to_rad(4.0)      # radians
@export var trauma_power := 2.0                    # nonlinear falloff
@export var trauma_decay := 1.2                    # trauma lost per second
@export var noise_speed := 25.0                    # how fast we scrub through noise

# Internal variables
var trauma := 0.0
var _noise := FastNoiseLite.new()
var _noise_t := 0.0

func _ready() -> void:
	_noise.seed = randi()
	_noise.frequency = 0.5


func _physics_process(delta: float) -> void:
	var center_pos := sub_viewport_container.global_position + (sub_viewport_container.size / 2)

	var target_offset := player.velocity * velocity_influence
	var max_follow_offset := 50.0
	target_offset.x = clamp(target_offset.x, -max_follow_offset, max_follow_offset)
	target_offset.y = clamp(target_offset.y, -max_follow_offset, max_follow_offset)

	var target_pos = center_pos + target_offset
	global_position = global_position.lerp(target_pos, smooth_speed * delta)

	_update_shake(delta)


func _update_shake(delta: float) -> void:
	trauma = max(trauma - trauma_decay * delta, 0.0)
	var amount := pow(trauma, trauma_power)

	if amount > 0.0:
		_noise_t += delta * noise_speed
		# Offset x/y and roll each sample a different noise "channel"
		# so they're decorrelated, by shifting the seed value passed in.
		offset.x = max_shake_offset.x * amount * _noise.get_noise_2d(_noise_t, 0.0)
		offset.y = max_shake_offset.y * amount * _noise.get_noise_2d(_noise_t, 100.0)
		rotation = max_shake_roll * amount * _noise.get_noise_2d(_noise_t, 200.0)
	else:
		offset = Vector2.ZERO
		rotation = 0.0


func apply_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)


func camera_shake(strength: float = 0.6) -> void:
	apply_trauma(strength)
