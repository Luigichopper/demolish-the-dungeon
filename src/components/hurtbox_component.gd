# hurtbox_component.gd
extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func take_damage(amount: float) -> void:
	return
