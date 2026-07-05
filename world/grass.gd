extends Node2D

@onready var grass_area: Area2D = $Area2D;

func _ready() -> void:
	grass_area.area_entered.connect(_on_area_2d_area_entered);

func _on_area_2d_area_entered(_area: Area2D) -> void:
	queue_free();
