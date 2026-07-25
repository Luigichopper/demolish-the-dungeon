# health_component.gd
extends Node2D
class_name HealthComponent

signal health_changed(current: float, max: float)
signal died

var max_health: float = 10.0
var current_health: float

func initialize(new_max_health: float) -> void:
	max_health = new_max_health
	current_health = max_health
	health_changed.emit(current_health, max_health)

func take_damage(amount: float) -> void:
	current_health = max(0.0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health == 0:
		died.emit()
