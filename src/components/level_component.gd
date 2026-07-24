# level_component.gd
extends Node
class_name LevelComponent

@export var current_level: int = 1
@export var health_component: HealthComponent
@export var hitbox_component: HitboxComponent

# Temporary base stats (Replace this with a YARD database query later)
@export var base_hp: float = 50.0
@export var hp_growth: float = 5.0
@export var base_damage: float = 10.0
@export var damage_growth: float = 2.0

func _ready() -> void:
	# Wait for sibling components to be ready
	await owner.ready 
	apply_stats()

func apply_stats() -> void:
	# 1. Calculate stats based on level
	var calculated_hp = base_hp + (hp_growth * (current_level - 1))
	var calculated_damage = base_damage + (damage_growth * (current_level - 1))
	
	# 2. Push to HealthComponent
	if health_component:
		health_component.initialize(calculated_hp)
		
	# 3. Push to HitboxComponent
	if hitbox_component:
		hitbox_component.damage = calculated_damage
