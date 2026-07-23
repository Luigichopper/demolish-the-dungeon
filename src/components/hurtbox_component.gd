# res://src/core/combat/hurtbox.gd
class_name Hurtbox
extends Area2D

signal hit(damage: float, source: Node)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage"):
		hit.emit(area.get_damage(), area)
