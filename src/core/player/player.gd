# player.gd
extends CharacterBody2D
class_name Player

const WALK_SPEED: float = 80.0
const RUN_SPEED: float = 130.0

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@export var low_res_camera: Camera2D
@export var state_machine: StateMachine
@export var health_component: HealthComponent
@export var hurtbox_component: HurtboxComponent

# For debug purposes
@export var state_label: Label
