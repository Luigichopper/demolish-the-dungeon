# low_res_camera.gd
extends Camera2D

@export var follow_target: Node2D
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

func _process(delta: float) -> void:
	global_position = follow_target.global_position.round()
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
