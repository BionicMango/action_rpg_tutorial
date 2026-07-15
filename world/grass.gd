extends Node2D

@export var grass_effect: PackedScene
@onready var hurtbox: Hurtbox = $Hurtbox

func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)

func _on_hurt(_other_hitbox: Area2D) -> void:
	var grass_effect_instance = grass_effect.instantiate()
	get_tree().current_scene.add_child(grass_effect_instance)
	grass_effect_instance.global_position = global_position
	queue_free()
