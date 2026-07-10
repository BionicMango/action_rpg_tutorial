class_name Hitbox extends Area2D;

@export var damage: float = 1.0;
@export var knockback_amount: float = 200.0;
@export var knockback_dir: Vector2;
@export var stores_hit_targets: bool = false;

# to track what targets have been hit
var hit_targets: Array;

# cleared whenever beginning attack animation (prevents undesired double attacks)
func clear_hit_targets() -> void:
	hit_targets.clear();
