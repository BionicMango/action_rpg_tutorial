extends Node2D

const grass_effect = preload("res://effects/grass_effect.tscn");
@onready var grass_area: Area2D = $Area2D;

func _ready() -> void:
	grass_area.area_entered.connect(_on_area_2d_area_entered);

func _on_area_2d_area_entered(_area: Area2D) -> void:
	var grass_effect_instance = grass_effect.instantiate();
	get_tree().current_scene.add_child(grass_effect_instance);
	grass_effect_instance.position = position;
	queue_free();
