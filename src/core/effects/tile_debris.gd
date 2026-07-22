# res://src/core/effects/tile_debris.gd
extends GPUParticles2D

func _ready() -> void:
	emitting = true
	# Auto-free the node once all particles disappear
	finished.connect(queue_free)
